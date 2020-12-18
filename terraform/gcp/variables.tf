variable "project_name" {
  description = "The name of the project to instanciate the instance at."
  default     = "egxteam"
}

variable "region_name" {
  description = "The region that this terraform configuration will instanciate at."
  default     = "us-west1"
}

variable "zone_name" {
  description = "The zone that this terraform configuration will instanciate at."
  default     = "us-west1-b"
}

variable "machine_size" {
  description = "The size that this instance will be."
  default     = "e2-medium"
}

variable "image_name" {
  description = "The kind of VM this instance will become"
  default     = "ubuntu-os-cloud/ubuntu-1804-bionic-v20190403"
}

variable "private_key_path" {
  description = "The path to the private key used to connect to the instance"
  default     = "~/.ssh/google_compute_engine"
}

variable "username" {
  description = "The name of the user that will be used to remote exec the script"
  default     = "aguda"
}

variable "worker_count" {
  default = 2
}
variable "master_count" {
  default = 1
}
