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

resource "google_compute_address" "static" {
  name = "ipv4-address"
}

data "google_compute_default_service_account" "default" {
}

resource "google_compute_instance" "vm_instance" {
  name         = "marko-vpn-instance"
  machine_type = "e2-standard-2"
  tags         = ["http-server", "https-server"]

  boot_disk {
    initialize_params {
      image = "debian-11-bullseye-v20220920"
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.static.address
    }
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = data.google_compute_default_service_account.default.email
    scopes = [ "cloud-platform" ]
  }

  # metadata_startup_script = file("~/workspace/terraform/vpn/vm_start_script.sh")
}

resource "google_compute_firewall" "http" {
  name    = "default-allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags   = ["http-server"]
}

resource "google_compute_firewall" "https" {
  name    = "default-allow-https"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  target_tags   = ["https-server"]
}