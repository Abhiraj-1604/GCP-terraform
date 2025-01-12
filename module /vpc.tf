locals {
  network_name = var.network-name
}

resource "google_compute_network" "vpc" {
  name                    = var.network-name
  auto_create_subnetworks = false

  description = "VPC for GCP resources"

  labels = {
    env = var.env
  }
}

resource "google_compute_subnetwork" "public_subnet" {
  count       = var.pub-subnet-count
  name        = "${var.pub-sub-name}-${count.index + 1}"
  ip_cidr_range = element(var.pub-cidr-block, count.index)
  region      = element(var.pub-region, count.index)
  network     = google_compute_network.vpc.id

  labels = {
    env = var.env
    role = "public"
  }
}

resource "google_compute_subnetwork" "private_subnet" {
  count       = var.pri-subnet-count
  name        = "${var.pri-sub-name}-${count.index + 1}"
  ip_cidr_range = element(var.pri-cidr-block, count.index)
  region      = element(var.pri-region, count.index)
  network     = google_compute_network.vpc.id

  labels = {
    env = var.env
    role = "private"
  }
}

resource "google_compute_router" "nat_router" {
  name    = var.router-name
  network = google_compute_network.vpc.id
  region  = var.region
}

resource "google_compute_router_nat" "nat_gateway" {
  name                                = var.nat-name
  router                              = google_compute_router.nat_router.name
  region                              = var.region
  nat_ip_allocate_option              = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

resource "google_compute_firewall" "allow_internal" {
  name    = var.allow-internal-fw
  network = google_compute_network.vpc.id

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = ["10.0.0.0/8"] # Adjust to your CIDR block

  target_tags = ["internal"]
}

resource "google_compute_firewall" "allow_external" {
  name    = var.allow-external-fw
  network = google_compute_network.vpc.id

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["external"]
}
