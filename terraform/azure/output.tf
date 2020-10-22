output "tls_private_key" {
    value = tls_private_key.example_ssh.private_key_pem 
}

data "template_file" "masters_ansible" {
  template = "$${host} ansible_ssh_host=$${host} ansible_ssh_port=22 ansible_ssh_user=azureuser ansible_ssh_private_key_file=../terraform/azure/azure.pem ansible_ssh_extra_args='-o StrictHostKeyChecking=no'"
  count = var.master_count  
  vars = {
    host = "${azurerm_linux_virtual_machine.master[count.index].public_ip_address}"
  }
}

data "template_file" "workers_ansible" {
  template = "$${host} ansible_ssh_host=$${host} ansible_ssh_port=22 ansible_ssh_user=azureuser ansible_ssh_private_key_file=../terraform/azure/azure.pem ansible_ssh_extra_args='-o StrictHostKeyChecking=no'"
  count = var.worker_count
  vars = {
    host = "${azurerm_linux_virtual_machine.worker[count.index].public_ip_address}"
  }
}


data "template_file" "inventory" {
  template = "\n[k8s-masters]\n$${masters}\n\n[k8s-workers]\n$${workers}"
  vars = {
    masters = "${join("\n",data.template_file.masters_ansible.*.rendered)}"
    workers = "${join("\n",data.template_file.workers_ansible.*.rendered)}"
  }
}

output "inventory" {
  value = "${data.template_file.inventory.rendered}"
}
