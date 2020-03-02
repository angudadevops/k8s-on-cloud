<h1> Kubernetes on AWS with Terraform </h1>

This repository helps to spin up AWS environment and create kubernetes cluster on top of that. 

- Prerequisites
  - AWS account details
  - Ansible on your local machine
  - Terraform on your local machine 

### Usage

Update the aws account details in terrform varaiable file, then run the below command to install kubernetes cluster on AWS 

```
bash k8scluster.sh
```

To clean up the AWS environment with kubernetes, run the below command

```
cd terrform
terraform destroy -auto-approve 
```

