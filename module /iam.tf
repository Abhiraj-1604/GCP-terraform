locals {
  cluster_name = var.cluster_name
}

resource "random_integer" "random_suffix" {
  min = 1000
  max = 9999
}

# Service Account for GKE Cluster
resource "google_service_account" "gke_cluster_service_account" {
  count        = var.is_gke_role_enabled ? 1 : 0
  account_id   = "${local.cluster_name}-cluster-${random_integer.random_suffix.result}"
  display_name = "GKE Cluster Service Account"
  project      = var.project_id
}

# Service Account for GKE Node Group
resource "google_service_account" "gke_nodegroup_service_account" {
  count        = var.is_gke_nodegroup_role_enabled ? 1 : 0
  account_id   = "${local.cluster_name}-nodegroup-${random_integer.random_suffix.result}"
  display_name = "GKE Node Group Service Account"
  project      = var.project_id
}

# Attach GKE Cluster Role (similar to EKS Cluster Policy in AWS)
resource "google_project_iam_member" "gke_cluster_role_attachment" {
  count     = var.is_gke_role_enabled ? 1 : 0
  project   = var.project_id
  role      = "roles/container.clusterViewer"  # Adjust this to your needs
  member    = "serviceAccount:${google_service_account.gke_cluster_service_account[count.index].email}"
}

# Attach GKE Node Group Role (similar to EKS Worker Node Policy in AWS)
resource "google_project_iam_member" "gke_nodegroup_role_attachment" {
  count     = var.is_gke_nodegroup_role_enabled ? 1 : 0
  project   = var.project_id
  role      = "roles/container.node"  # Adjust this to your needs
  member    = "serviceAccount:${google_service_account.gke_nodegroup_service_account[count.index].email}"
}

# Attach additional GKE Node Group Policies
resource "google_project_iam_member" "gke_ec2_container_registry_role_attachment" {
  count     = var.is_gke_nodegroup_role_enabled ? 1 : 0
  project   = var.project_id
  role      = "roles/storage.objectViewer"  # GCR read-only access
  member    = "serviceAccount:${google_service_account.gke_nodegroup_service_account[count.index].email}"
}

resource "google_project_iam_member" "gke_ebs_csi_driver_role_attachment" {
  count     = var.is_gke_nodegroup_role_enabled ? 1 : 0
  project   = var.project_id
  role      = "roles/storage.admin"  # Adjust this to match EBS CSI requirements
  member    = "serviceAccount:${google_service_account.gke_nodegroup_service_account[count.index].email}"
}

# IAM Policy for OIDC (Similar to IAM Role for OIDC in AWS)
resource "google_iam_policy" "gke_oidc_policy" {
  binding {
    role    = "roles/storage.objectViewer"  # Adjust this role as needed
    members = [
      "serviceAccount:${google_service_account.gke_cluster_service_account[0].email}"
    ]
  }
}

# Attach OIDC Policy to the GKE Cluster Service Account
resource "google_service_account_iam_policy" "gke_oidc_policy_attachment" {
  service_account_id = google_service_account.gke_cluster_service_account[0].name
  policy_data        = google_iam_policy.gke_oidc_policy.policy_data
}

