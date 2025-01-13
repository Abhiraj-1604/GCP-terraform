variable "gcp-region" {}
variable "gcp-project-id" {}
variable "env" {}
variable "cluster-name" {}
variable "vpc-cidr-block" {}
variable "vpc-name" {}
variable "igw-name" {}
variable "pub-subnet-count" {}
variable "pub-cidr-block" {
  type = list(string)
}
variable "pub-availability-zone" {
  type = list(string)
}
variable "pub-sub-name" {}
variable "pri-subnet-count" {}
variable "pri-cidr-block" {
  type = list(string)
}
variable "pri-availability-zone" {
  type = list(string)
}
variable "pri-sub-name" {}
variable "public-rt-name" {}
variable "private-rt-name" {}
variable "nat-name" {}
variable "firewall-name" {}

# GKE
variable "is-gke-cluster-enabled" {}
variable "cluster-version" {}
variable "enable-private-nodes" {
  description = "Whether to enable private nodes for the GKE cluster."
  type        = bool
  default     = true
}
variable "enable-public-endpoint" {
  description = "Whether to enable a public endpoint for the GKE cluster."
  type        = bool
  default     = false
}
variable "node_pool_name" {}

variable "ondemand_machine_types" {
  description = "List of machine types for on-demand nodes."
  type        = list(string)
  default     = ["e2-medium"]
}

variable "preemptible_machine_types" {
  description = "List of machine types for preemptible nodes."
  type        = list(string)
  default     = ["e2-standard-4", "e2-standard-2", "e2-medium"]
}
variable "desired_capacity_ondemand" {}
variable "min_capacity_ondemand" {}
variable "max_capacity_ondemand" {}
variable "desired_capacity_preemptible" {}
variable "min_capacity_preemptible" {}
variable "max_capacity_preemptible" {}

variable "addons" {
  type = list(object({
    name    = string
    version = string
  }))
}
