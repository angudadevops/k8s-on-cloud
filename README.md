[![HitCount](http://hits.dwyl.com/angudadevops/k8s-on-cloud.svg)](http://hits.dwyl.com/angudadevops/k8s-on-cloud)

<h1> Kubernetes on Cloud with Terraform </h1> 

This repository helps to spin up cloud environment and create kubernetes cluster on top of that using kubeadm

- Prerequisites
  - Linux machine or Mac Os Machine

### Usage

#### AWS
Update the aws account details in terrform varaiable file, then run the below command to install kubernetes cluster on 

```
bash k8scluster.sh aws
```

To clean up the AWS environment with kubernetes, run the below command

```
cd terrform/aws
terraform destroy -auto-approve
```

#### Azure
Make sure you have azure account setup, as below command will open to login to your azure account. Once succesful login it will provision k8s cluster on Azure Virtual Machines

```
bash k8scluster.sh azure
```

To clean up the AWS environment with kubernetes, run the below command

```
cd terrform/azure
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
