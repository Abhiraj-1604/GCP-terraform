locals {
  org = "medium"
  env = var.env
}

module "gke" {
  source = "../module"

  env                   = var.env
  cluster-name          = "${local.env}-${local.org}-${var.cluster-name}"
  cidr-block            = var.vpc-cidr-block
  vpc-name              = "${local.env}-${local.org}-${var.vpc-name}"
  igw-name              = "${local.env}-${local.org}-${var.igw-name}"
  pub-subnet-count      = var.pub-subnet-count
  pub-cidr-block        = var.pub-cidr-block
  pub-availability-zone = var.pub-availability-zone
  pub-sub-name          = "${local.env}-${local.org}-${var.pub-sub-name}"
  pri-subnet-count      = var.pri-subnet-count
  pri-cidr-block        = var.pri-cidr-block
  pri-availability-zone = var.pri-availability-zone
  pri-sub-name          = "${local.env}-${local.org}-${var.pri-sub-name}"
  public-rt-name        = "${local.env}-${local.org}-${var.public-rt-name}"
  private-rt-name       = "${local.env}-${local.org}-${var.private-rt-name}"
  nat-name              = "${local.env}-${local.org}-${var.nat-name}"
  firewall-name         = "${local.env}-${local.org}-${var.firewall-name}"

  is_gke_cluster_enabled        = var.is-gke-cluster-enabled
  cluster-version               = var.cluster-version
  enable-private-nodes          = var.enable-private-nodes
  enable-public-endpoint        = var.enable-public-endpoint
  node_pool_name                = "${local.env}-${local.org}-${var.node-pool-name}"
  ondemand_machine_types        = var.ondemand_machine_types
  preemptible_machine_types     = var.preemptible_machine_types
  desired_capacity_ondemand     = var.desired_capacity_ondemand
  min_capacity_ondemand         = var.min_capacity_ondemand
  max_capacity_ondemand         = var.max_capacity_ondemand
  desired_capacity_preemptible  = var.desired_capacity_preemptible
  min_capacity_preemptible      = var.min_capacity_preemptible
  max_capacity_preemptible      = var.max_capacity_preemptible

  addons = var.addons
}
