<h1> Terraform on Azure </h1>

For kubernetes with kubeadm multi node cluster we need to bring up multi nodes with help of terraform 

- Prerequisites
  - azure account

Make sure you have an access to your azure account 

If you want to modify any details like number of worker node, use variable.tf file to refer that

### Usage

Make sure to inititate the terraform to load all plugins

```
terraform init
```

Now verify the terrafor plan with below command 

```
terraform plan
```

Once verify the plan, now apply the terraform state to aws account 

```
terraform apply -auto-aprrove
```

To create a ansible inventory, run the below command . if you want to change the format of inventory file modify outputs.tf file. 

```
terraform output inventory > ../ansible/inventory
terraform output tls_private_key > azure.pem
```

