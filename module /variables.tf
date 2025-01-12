variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "env" {
  description = "The environment name (e.g., dev, prod)"
  type        = string
}

variable "igw_name" {
  description = "The name of the internet gateway"
  type        = string
}

variable "pub_subnet_count" {
  description = "Number of public subnets"
  type        = number
}

variable "pub_cidr_block" {
  description = "The CIDR blocks for the public subnets"
  type        = list(string)
}

variable "pub_availability_zone" {
  description = "The availability zones for the public subnets"
  type        = list(string)
}

variable "pub_sub_name" {
  description = "The name of the public subnet"
  type        = string
}

variable "pri_subnet_count" {
  description = "Number of private subnets"
  type        = number
}

variable "pri_cidr_block" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)
}

variable "pri_availability_zone" {
  description = "The availability zones for the private subnets"
  type        = list(string)
}

variable "pri_sub_name" {
  description = "The name of the private subnet"
  type        = string
}

variable "public_rt_name" {
  description = "The name of the public route table"
  type        = string
}

variable "private_rt_name" {
  description = "The name of the private route table"
  type        = string
}

variable "eip_name" {
  description = "The name of the external IP"
  type        = string
}

variable "ngw_name" {
  description = "The name of the NAT gateway"
  type        = string
}

variable "gke_sg" {
  description = "The name of the GKE security group"
  type        = string
}

# IAM
variable "is_gke_role_enabled" {
  description = "Whether the GKE role is enabled"
  type        = bool
}

variable "is_gke_nodegroup_role_enabled" {
  description = "Whether the GKE node pool role is enabled"
  type        = bool
}

# GKE
variable "is_gke_cluster_enabled" {
  description = "Whether the GKE cluster is enabled"
  type        = bool
}

variable "cluster_version" {
  description = "The GKE cluster version"
  type        = string
}

variable "endpoint_private_access" {
  description = "Whether private endpoint access is enabled for GKE"
  type        = bool
}

variable "endpoint_public_access" {
  description = "Whether public endpoint access is enabled for GKE"
  type        = bool
}

variable "addons" {
  description = "List of add-ons for GKE"
  type = list(object({
    name    = string
    version = string
  }))
}

variable "ondemand_machine_type" {
  description = "Machine type for the on-demand node pool"
  type        = string
}

variable "spot_machine_type" {
  description = "Machine type for the spot node pool"
  type        = string
}

variable "desired_capacity_on_demand" {
  description = "Desired capacity for the on-demand node pool"
  type        = number
}

variable "min_capacity_on_demand" {
  description = "Minimum capacity for the on-demand node pool"
  type        = number
}

variable "max_capacity_on_demand" {
  description = "Maximum capacity for the on-demand node pool"
  type        = number
}

variable "desired_capacity_spot" {
  description = "Desired capacity for the spot node pool"
  type        = number
}

variable "min_capacity_spot" {
  description = "Minimum capacity for the spot node pool"
  type        = number
}

variable "max_capacity_spot" {
  description = "Maximum capacity for the spot node pool"
  type        = number
}

variable "network" {
  description = "The network name"
  type        = string
}

variable "subnetwork" {
  description = "The subnetwork name"
  type        = string
}

variable "project_id" {
  description = "The project ID"
  type        = string
}

variable "cluster_location" {
  description = "The GCP region where the GKE cluster will be created"
  type        = string
}
