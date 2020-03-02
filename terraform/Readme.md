<h1> Terraform on AWS </h1>

For kubernetes multi node cluster we need to bring up multi nodes with help of terraform 

- Prerequisites
  - aws_access_key
  - aws_secret_key
  - aws_keypair_name

Make sure to update these values on varaiable.tf to access your aws account 

If you want to modify any details like use another aws AMI, use variable.tf file to refer that

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
```

