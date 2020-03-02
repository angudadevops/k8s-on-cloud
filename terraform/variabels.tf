variable "access_key" {
  default = "AKIAYXCTGPBA24LFMYUV"
}
variable "secret_key" {
  default = "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"  
}
variable "worker_count" {
  default = 2
}
variable "master_count" {
  default = 1
}
variable "key_name" {
  default = "awstest"
}
variable "region" {
  default = "us-west-1"
}
variable "ami" {
  default = "ami-03ba3948f6c37a4b0"
}
variable "node_instance_type" {
  default = "t2.medium"
}

variable "master_instance_type" {
  default = "t2.medium"
}
variable "master_tags" {
  default = "csbmaster"
}

variable "worker_tags" {
  default = "csbworker"
}
variable "state" {
  default = "running"
}
