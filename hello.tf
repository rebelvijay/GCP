terraform {
  required_version = ">= 1.3"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

# =========================
# VARIABLES
# =========================

variable "project_id" {
  default = "ci-cd-496905"
}

variable "region" {
  default = "asia-south1"
}

variable "zone" {
  default = "asia-south1-a"
}

variable "vm_name" {
  default = "Junki-vm3"
}

variable "machine_type" {
  default = "e2-medium"
}

variable "ssh_user" {
  default = "ubuntu"
}

variable "public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

# =========================
# PROVIDER
# =========================

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# =========================
# VM INSTANCE
# =========================

resource "google_compute_instance" "vm_instance" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone

  tags = ["terraform-vm"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
    }
  }

  network_interface {
    network = "default"

    access_config {
      # Assign public IP
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.public_key_path)}"
  }

  labels = {
    environment = "dev"
  }
}

# =========================
# OUTPUTS
# =========================

output "vm_name" {
  value = google_compute_instance.vm_instance.name
}

output "external_ip" {
  value = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}