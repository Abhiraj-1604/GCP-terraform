locals {
  cluster_name = var.cluster_name
}

# Create the GKE Cluster
resource "google_container_cluster" "gke" {
  count       = var.is_gke_cluster_enabled == true ? 1 : 0
  name        = var.cluster_name
  location    = var.cluster_location
  initial_node_count = 1  # Adjust based on your requirements

  # Configure VPC, subnets, and other settings
  network     = var.network
  subnetwork  = var.subnetwork

  # Enable private and public endpoint access
  private_cluster_config {
    enable_private_endpoint = var.endpoint_private_access
    enable_public_endpoint  = var.endpoint_public_access
  }

  # Tags
  resource_labels = {
    Name = var.cluster_name
    Env  = var.env
  }

  # Authentication and permissions (config_map is not directly supported in GKE)
  master_auth {
    username = "admin"
    password = "adminpassword"  # Use a more secure method for passwords
  }
}

# OIDC for GKE (GKE does not require an OIDC provider setup like EKS)
# You can configure GKE to use the Google Cloud Identity provider directly

# GKE Add-ons (e.g., HorizontalPodAutoscaler, NetworkPolicy)
resource "google_container_cluster_addon" "gke_addons" {
  for_each      = { for idx, addon in var.addons : idx => addon }
  cluster       = google_container_cluster.gke[0].name
  location      = var.cluster_location
  addon         = each.value.name
  version       = each.value.version
}

# Create Node Pools for GKE (On-Demand and Spot equivalent)
resource "google_container_node_pool" "ondemand_node_pool" {
  count            = var.is_gke_ondemand_nodepool_enabled ? 1 : 0
  name             = "${var.cluster_name}-ondemand-pool"
  cluster          = google_container_cluster.gke[0].name
  location         = var.cluster_location
  node_config {
    machine_type = var.ondemand_machine_type
    disk_size_gb = 50  # Adjust disk size as needed
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  # Autoscaling configuration for the node pool
  autoscaling {
    min_node_count = var.min_capacity_on_demand
    max_node_count = var.max_capacity_on_demand
  }

  # Tags and Labels
  node_labels = {
    type = "ondemand"
  }

  tags = {
    Name = "${var.cluster_name}-ondemand-nodes"
  }
}

resource "google_container_node_pool" "spot_node_pool" {
  count            = var.is_gke_spot_nodepool_enabled ? 1 : 0
  name             = "${var.cluster_name}-spot-pool"
  cluster          = google_container_cluster.gke[0].name
  location         = var.cluster_location
  node_config {
    machine_type = var.spot_machine_type
    disk_size_gb = 50  # Adjust disk size as needed
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  # Autoscaling configuration for the node pool
  autoscaling {
    min_node_count = var.min_capacity_spot
    max_node_count = var.max_capacity_spot
  }

  # Tags and Labels
  node_labels = {
    type      = "spot"
    lifecycle = "spot"
  }

  tags = {
    Name = "${var.cluster_name}-spot-nodes"
  }
}

# Create a service account for the GKE cluster (equivalent to EKS IAM roles)
resource "google_service_account" "gke_cluster_service_account" {
  account_id   = "${var.cluster_name}-cluster-service-account"
  display_name = "GKE Cluster Service Account"
  project      = var.project_id
}

resource "google_service_account" "gke_node_pool_service_account" {
  account_id   = "${var.cluster_name}-node-pool-service-account"
  display_name = "GKE Node Pool Service Account"
  project      = var.project_id
}

# Assign IAM roles to the service account
resource "google_project_iam_member" "gke_cluster_service_account_role" {
  project = var.project_id
  role    = "roles/container.clusterViewer"  # Adjust this role as necessary
  member  = "serviceAccount:${google_service_account.gke_cluster_service_account.email}"
}

resource "google_project_iam_member" "gke_node_pool_service_account_role" {
  project = var.project_id
  role    = "roles/container.node"  # Adjust this role as necessary
  member  = "serviceAccount:${google_service_account.gke_node_pool_service_account.email}"
}
