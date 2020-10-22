provider "azurerm" {
  version         = "2.0.0"
  features {}
}

resource "azurerm_resource_group" "azure-terraform" {
 name     = "acctestrg"
 location = "West US 2"
}

resource "azurerm_virtual_network" "azure-terraform" {
 name                = "acctvn"
 address_space       = ["10.0.0.0/16"]
 location            = azurerm_resource_group.azure-terraform.location
 resource_group_name = azurerm_resource_group.azure-terraform.name
}

resource "azurerm_subnet" "azure-terraform" {
 name                 = "acctsub"
 resource_group_name  = azurerm_resource_group.azure-terraform.name
 virtual_network_name = azurerm_virtual_network.azure-terraform.name
 address_prefix       = "10.0.2.0/24"
}

resource "azurerm_public_ip" "master" {
 count                        = var.master_count
 name                         = "accpublicIP-master${count.index}"
 location                     = azurerm_resource_group.azure-terraform.location
 resource_group_name          = azurerm_resource_group.azure-terraform.name
 allocation_method            = "Dynamic"
}


resource "azurerm_public_ip" "worker" {
 count                        = var.worker_count 
 name                         = "accpublicIP-worker${count.index}"
 location                     = azurerm_resource_group.azure-terraform.location
 resource_group_name          = azurerm_resource_group.azure-terraform.name
 allocation_method            = "Dynamic"
}

resource "azurerm_network_interface" "master" {
 count               = var.master_count
 name                = "acctni-master${count.index}"
 location            = azurerm_resource_group.azure-terraform.location
 resource_group_name = azurerm_resource_group.azure-terraform.name

 ip_configuration {
   name                          = "testConfiguration"
   subnet_id                     = azurerm_subnet.azure-terraform.id
   private_ip_address_allocation = "dynamic"
   public_ip_address_id          = azurerm_public_ip.master[count.index].id
 }
}

resource "azurerm_network_interface" "worker" {
 count               = var.worker_count
 name                = "acctni-worker${count.index}"
 location            = azurerm_resource_group.azure-terraform.location
 resource_group_name = azurerm_resource_group.azure-terraform.name

 ip_configuration {
   name                          = "testConfiguration"
   subnet_id                     = azurerm_subnet.azure-terraform.id
   private_ip_address_allocation = "dynamic"
   public_ip_address_id          = azurerm_public_ip.worker[count.index].id
 }
}

resource "azurerm_managed_disk" "worker" {
 count                = var.worker_count
 name                 = "datadisk_existing-worker_${count.index}"
 location             = azurerm_resource_group.azure-terraform.location
 resource_group_name  = azurerm_resource_group.azure-terraform.name
 storage_account_type = "Standard_LRS"
 create_option        = "Empty"
 disk_size_gb         = "1023"
}

resource "azurerm_managed_disk" "master" {
 count                = var.master_count
 name                 = "datadisk_existing-master_${count.index}"
 location             = azurerm_resource_group.azure-terraform.location
 resource_group_name  = azurerm_resource_group.azure-terraform.name
 storage_account_type = "Standard_LRS"
 create_option        = "Empty"
 disk_size_gb         = "1023"
}

# Create (and display) an SSH key
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "azurerm_linux_virtual_machine" "master" {
 count                 = var.master_count
 name                  = "acctvm-master${count.index}"
 location              = azurerm_resource_group.azure-terraform.location
 resource_group_name   = azurerm_resource_group.azure-terraform.name
 network_interface_ids = azurerm_network_interface.master.*.id
 size               = "Standard_B2s"

 # Uncomment this line to delete the OS disk automatically when deleting the VM
 # delete_os_disk_on_termination = true

 # Uncomment this line to delete the data disks automatically when deleting the VM
 # delete_data_disks_on_termination = true

 source_image_reference {
   publisher = "Canonical"
   offer     = "UbuntuServer"
   sku       = "18.04-LTS"
   version   = "latest"
 }

 os_disk {
    name              = "accdisk-master-${count.index}"
    caching           = "ReadWrite"
    storage_account_type = "Premium_LRS"
 }

 disable_password_authentication = true
 admin_username = "azureuser"

 admin_ssh_key {
     username       = "azureuser"
     public_key     =  tls_private_key.example_ssh.public_key_openssh
 }

 tags = {
   environment = "master"
 }
}

resource "azurerm_linux_virtual_machine" "worker" {
 count                 = var.worker_count
 name                  = "acctvm-worker${count.index}"
 location              = azurerm_resource_group.azure-terraform.location
 resource_group_name   = azurerm_resource_group.azure-terraform.name
 network_interface_ids = [element(azurerm_network_interface.worker.*.id, count.index)]
 size               = "Standard_DS1_v2"

 # Uncomment this line to delete the OS disk automatically when deleting the VM
 # delete_os_disk_on_termination = true

 # Uncomment this line to delete the data disks automatically when deleting the VM
 # delete_data_disks_on_termination = true

 source_image_reference {
   publisher = "Canonical"
   offer     = "UbuntuServer"
   sku       = "18.04-LTS"
   version   = "latest"
 }

 os_disk {
    name              = "accdisk-worker-${count.index}"
    caching           = "ReadWrite"
    storage_account_type = "Premium_LRS"
 }

 disable_password_authentication = true
 admin_username = "azureuser"

 admin_ssh_key {
     username       = "azureuser"
     public_key     =  tls_private_key.example_ssh.public_key_openssh
 }

 tags = {
   environment = "worker"
 }
}

