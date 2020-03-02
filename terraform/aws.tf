provider "aws" {
  access_key= var.access_key
  secret_key= var.secret_key
  region= var.region
}

resource "aws_instance" "master" {
  ami= var.ami
  key_name= var.key_name
  instance_type= var.master_instance_type
  count = var.master_count
  tags = {
    Name = "${var.master_tags}-${count.index}"
  }
}

resource "aws_instance" "worker" {
  ami= var.ami
  key_name= var.key_name
  instance_type= var.node_instance_type
  count = var.worker_count
  tags = {
    Name = "${var.worker_tags}-${count.index}"
  }
}

resource "aws_eip" "eip-master" {
    count = var.master_count
    instance = element(aws_instance.master.*.id,count.index)
    vpc = true
    tags = {
      Name = "${var.master_tags}-${count.index}"
    }
}

resource "aws_eip" "eip-worker" {
    count = var.worker_count
    instance = element(aws_instance.worker.*.id,count.index)
    vpc = true
    tags = {
      Name = "${var.worker_tags}-${count.index}"
    }

}

