[![HitCount](http://hits.dwyl.com/angudadevops/k8s-on-cloud.svg)](http://hits.dwyl.com/angudadevops/k8s-on-cloud)

<h1> Kubernetes on cloud with Terraform </h1> 

This repository helps to spin up AWS environment and create kubernetes cluster on top of that. 

- Prerequisites
  - AWS account details
  - Ansible on your local machine
  - Terraform on your local machine 
  - EC2 instance Key Pair

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

### Troubleshooting

If you see any error with terraform apply, it could be issue with values from varaiables.tf like ami id. Please update and try to re run. To enable Terraform trace logs, please run below command before running k8scluster.sh
```
export TF_LOG=TRACE
```

To disable logs, run below command
```
export TF_LOG=
```
