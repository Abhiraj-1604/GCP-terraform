locals {
  cluster_name = var.cluster_name
}

# Gather the GKE cluster OIDC issuer URL (similar to AWS EKS OIDC URL)
data "google_container_cluster" "gke_cluster" {
  name     = local.cluster_name
  location = var.cluster_location
}

# TLS Certificate for GKE
data "tls_certificate" "gke_certificate" {
  url = data.google_container_cluster.gke_cluster.endpoint
}

# Define the IAM Policy for GKE OIDC (AssumeRoleWithWebIdentity equivalent)
data "google_iam_policy" "gke_oidc_assume_role_policy" {
  binding {
    role    = "roles/iam.serviceAccountTokenCreator"
    members = [
      "serviceAccount:${google_service_account.gke_cluster_service_account[0].email}"
    ]
  }
}

# Define the GKE OIDC service account
resource "google_service_account" "gke_cluster_service_account" {
  account_id   = "${local.cluster_name}-oidc-service-account"
  display_name = "GKE OIDC Service Account"
  project      = var.project_id
}

# IAM Policy attachment for GKE OIDC service account
resource "google_project_iam_member" "gke_oidc_policy_attachment" {
  project = var.project_id
  role    = "roles/iam.serviceAccountTokenCreator"  # Allows token creation for service account
  member  = "serviceAccount:${google_service_account.gke_cluster_service_account[0].email}"
}

# OIDC condition for specific service account (equivalent to AWS condition)
resource "google_project_iam_member" "gke_oidc_condition" {
  project = var.project_id
  role    = "roles/storage.objectViewer"  # Adjust this to your specific role
  member  = "serviceAccount:${google_service_account.gke_cluster_service_account[0].email}"

  condition {
    title       = "ServiceAccountCondition"
    description = "Only allow access for the specific service account"
    expression  = "resource.name == 'projects/${var.project_id}/serviceAccounts/${google_service_account.gke_cluster_service_account[0].email}'"
  }
}
