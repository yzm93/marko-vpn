terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = "asia-east2"
  zone    = "asia-east2-a"
}

resource "google_compute_network" "vpc_network" {
  name = "marko-vpn-network"
}

resource "google_compute_address" "static" {
  name = "ipv4-address"
}

resource "google_service_account" "default" {
  account_id   = "service_account_id"
  display_name = "Service Account"
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

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }

  # metadata_startup_script = file("~/workspace/terraform/vpn/vm_start_script.sh")
}