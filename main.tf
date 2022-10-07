terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
      zone    = "asia-east2-a"
    }
  }
}

provider "google" {
  project = var.project_id
}

resource "google_compute_network" "vpc_network" {
  name = "marko-vpn-network"
}

resource "google_compute_address" "static" {
  name = "ipv4-address"
}

resource "google_compute_instance" "vm_instance" {
  name         = "marko-vpn-instance"
  machine_type = "e2-standard-2"
  tags         = ["http-server", "https-server"]

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
      nat_ip = google_compute_address.static.address
    }
  }
}

resource "google_compute_firewall" "rules" {
  project     = var.project_id
  name        = "marko-vpn-instance-firewall-rule"
  network     = google_compute_network.vpc_network.name
  description = "Creates firewall rule targeting tagged instances"

  allow {
    protocol  = "tcp"
    ports     = ["80", "443"]
  }

  target_tags = ["http-server", "https-server"]
}
