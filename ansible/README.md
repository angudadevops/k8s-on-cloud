<h1> Install multi-node kubernetes cluster with Ansible Playbooks </h1>

- Prerequisites 
  - SSH trust setup from your local vm to remote hosts or use remote host private_key
    ```
      ssh-keygen -b 2048 -t rsa -f /root/.ssh/id_rsa -q -N ""
      ssh anguda@$host  | sudo -S mkdir /root/.ssh
      ssh anguda@$host | sudo -S touch /root/.ssh/authorized_keys
      ssh anguda@$host | sudo -S apt install git ansible vim sshpass openssh-server -y
      cat /root/.ssh/id_rsa.pub | ssh root@$host "cat >> /root/.ssh/authorized_keys"
    ```


This directory helps you to install kubernetes cluster with ansible playbooks. Please make sure to pass inventory file for each playbooks 

- inventory example 

```
[k8s-masters]
54.219.223.243 ansible_ssh_host=54.219.223.243 ansible_ssh_port=22 ansible_ssh_user=ubuntu ansible_ssh_extra_args='-o StrictHostKeyChecking=no'

[k8s-workers]
52.52.238.67 ansible_ssh_host=52.52.238.67 ansible_ssh_port=22 ansible_ssh_user=ubuntu ansible_ssh_extra_args='-o StrictHostKeyChecking=no'
52.8.50.178 ansible_ssh_host=52.8.50.178 ansible_ssh_port=22 ansible_ssh_user=ubuntu ansible_ssh_extra_args='-o StrictHostKeyChecking=no'
``` 
## Note

If you're using Terraform with Ansible for kubernetes cluster on AWS, you can ignore above steps as my scripts help you to generate ansible inventory. Above steps are for complete on bare metal

### Usage

First make sure to install the prerequisites.yaml to install all componenets 

```
ansible-playbook prerequisites.yaml -i inventory
```

Then run k8s.yaml to install kubernetes cluster with kubeadm 

```
ansible-playbook k8s.yaml -i inventory
```
 
