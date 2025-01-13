terraform {
  required_version = "~> 1.9.3"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.90.0"
    }
  }
  backend "gcs" {
    bucket = "my-gcp-bucket1122"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}
