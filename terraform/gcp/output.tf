data "template_file" "masters_ansible" {
  template = "$${host} ansible_ssh_host=$${host} ansible_ssh_port=22 ansible_ssh_user=aguda ansible_ssh_private_key_file=$${key} ansible_ssh_extra_args='-o StrictHostKeyChecking=no'"
  count = var.master_count  
  vars = {
    host = "${google_compute_instance.master[count.index].network_interface.0.access_config.0.nat_ip}"
    key = var.private_key_path
  }
}

data "template_file" "workers_ansible" {
  template = "$${host} ansible_ssh_host=$${host} ansible_ssh_port=22 ansible_ssh_user=aguda ansible_ssh_private_key_file=$${key} ansible_ssh_extra_args='-o StrictHostKeyChecking=no'"
  count = var.worker_count
  vars = {
    host = "${google_compute_instance.worker[count.index].network_interface.0.access_config.0.nat_ip}"
    key = var.private_key_path
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
