data "template_file" "masters_ansible" {
  template = "$${host} ansible_ssh_host=$${ip} ansible_ssh_port=22 ansible_ssh_user=ubuntu ansible_ssh_private_key_file=../terraform/aws/awstest.pem ansible_ssh_extra_args='-o StrictHostKeyChecking=no'"
  count = var.master_count
  vars = {
    host = "${aws_eip.eip-master.*.public_dns[count.index]}"
    ip = "${aws_eip.eip-master.*.public_ip[count.index]}"
  }
}

data "template_file" "workers_ansible" {
  template = "$${host} ansible_ssh_host=$${ip} ansible_ssh_port=22 ansible_ssh_user=ubuntu ansible_ssh_private_key_file=../terraform/aws/awstest.pem ansible_ssh_extra_args='-o StrictHostKeyChecking=no'"
  count = var.worker_count
  vars = {
    host = "${aws_eip.eip-worker.*.public_dns[count.index]}"
    ip = "${aws_eip.eip-worker.*.public_ip[count.index]}"
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
