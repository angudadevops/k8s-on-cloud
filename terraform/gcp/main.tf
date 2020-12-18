# This is the provider used to spin up the gcloud instance
provider "google" {
  project = var.project_name
  region  = var.region_name
  zone    = var.zone_name
}

# Locks the version of Terraform for this particular use case
terraform {
  required_version = "~>0.12.0"
}


# This creates the google instance
resource "google_compute_instance" "master" {
  name         = "k8s-master${count.index}"
  machine_type = var.machine_size
  count        = var.master_count

  boot_disk {
    initialize_params {
      image = var.image_name
    }
  }

  network_interface {
    network       = "default"
    # Associated our public IP address to this instance
    access_config {
      nat_ip = google_compute_address.master[count.index].address
    }
  }
}

resource "google_compute_instance" "worker" {
  name         = "k8s-worker${count.index}"
  machine_type = var.machine_size
  count        = var.worker_count

  boot_disk {
    initialize_params {
      image = var.image_name
    }
  }

  network_interface {
    network       = "default"
    # Associated our public IP address to this instance
    access_config {
      nat_ip = google_compute_address.worker[count.index].address
    }
  }
}

# We create a public IP address for our google compute instance to utilize
resource "google_compute_address" "master" {
  name = "master${count.index}-public-address"
  count        = var.master_count
}
resource "google_compute_address" "worker" {
  name = "worker${count.index}-public-address"
  count        = var.worker_count
}


