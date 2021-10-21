
variable "credentials_file" { 
  default = "../secrets/cis-91.key" 
}

variable "project" {
  default = "cis-91-fall-2021"
}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-c"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials_file)
  region  = var.region
  zone    = var.zone 
  project = var.project
}

resource "google_service_account" "proj1-service-account" {
  account_id   = "proj1-service-account"
  display_name = "proj1-service-account"
  description = "Service account for Project 1"
}

resource "google_project_iam_member" "project_member" {
  role = "roles/compute.imageUser"
  member = "serviceAccount:${google_service_account.proj1-service-account.email}"
}

resource "google_project_iam_member" "storage_access" {
  role = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.proj1-service-account.email}"
}
resource "google_compute_network" "vpc_network" {
  name = "cis91-network"
}

resource "google_compute_disk" "data_disk" {
  name = "data"
  type = "pd-standard"
  size = "100"
}

resource "google_compute_attached_disk" "data_disk" {
  instance = google_compute_instance.vm_instance.id
  disk = google_compute_disk.data_disk.id
  device_name = "data_disk"
}

resource "google_compute_instance" "vm_instance" {
  name         = "cis91"
  machine_type = "e2-micro"

  service_account {
    email  = google_service_account.proj1-service-account.email
    scopes = ["cloud-platform"]
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
  
  lifecycle {
  ignore_changes = [attached_disk]
  }
}

resource "google_compute_firewall" "default-firewall" {
  name = "default-firewall"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports = ["22, 80"]
  }
  source_ranges = ["0.0.0.0/0"]
}

output "external-ip" {
  value = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}
