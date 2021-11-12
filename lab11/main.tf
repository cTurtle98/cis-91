
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

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
resource "google_compute_network" "lab11_vpc_network" {
  name = "lab11-vpc-net"
  auto_create_subnetworks = "false"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork

# subnet 1
# net addr / mask: 10.0.0.0/8
# first addr: 10.0.0.1
# last addr: 10.255.255.254
# max hosts 16777214
resource "google_compute_subnetwork" "subnet_1" {
  name = "subnet-1"
  network = google_compute_network.lab11_vpc_network.id
  region        = "us-central1"
  ip_cidr_range = "10.0.0.0/8"
}

# subnet 2
# net addr / mask: 172.20.1.0/24
# first addr: 172.20.1.1
# last addr: 172.20.1.254
# max hosts 255
resource "google_compute_subnetwork" "subnet_2" {
  name = "subnet-2"
  network = google_compute_network.lab11_vpc_network.id
  region        = "us-central1"
  ip_cidr_range = "172.20.1.0/24"
}

# subnet 3
# net addr / mask: 192.168.0.0/16
# first addr: 192.168.0.1
# last addr: 192.168.255.254
# max hosts 65536
resource "google_compute_subnetwork" "subnet_3" {
  name = "subnet-3"
  network = google_compute_network.lab11_vpc_network.id
  region        = "us-central1"
  ip_cidr_range = "192.168.0.0/16"
}

resource "google_compute_instance" "vm_instance" {
  name         = "lab11-vm1"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = google_compute_network.lab11_vpc_network.name
    subnetwork = google_compute_subnetwork.subnet_1.name
    access_config {
    }
  }
}

resource "google_compute_firewall" "default-firewall" {
  name = "lab11-net1-firewall"
  network = google_compute_network.lab11_vpc_network.name
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}

output "external-ip" {
  value = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}
