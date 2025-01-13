env                   = "dev"
gcp-region            = "us-central1"
vpc-name              = "vpc"
vpc-cidr-block        = "10.16.0.0/16"
igw-name              = "internet-gateway"
pub-subnet-count      = 3
pub-cidr-block        = ["10.16.0.0/20", "10.16.16.0/20", "10.16.32.0/20"]
pub-availability-zone = ["us-central1-a", "us-central1-b", "us-central1-c"]
pub-sub-name          = "subnet-public"
pri-subnet-count      = 3
pri-cidr-block        = ["10.16.128.0/20", "10.16.144.0/20", "10.16.160.0/20"]
pri-availability-zone = ["us-central1-a", "us-central1-b", "us-central1-c"]
pri-sub-name          = "subnet-private"
public-rt-name        = "public-route-table"
private-rt-name       = "private-route-table"
nat-name              = "nat-router"
firewall-name         = "firewall-rules"

# GKE (Google Kubernetes Engine)
is-gke-cluster-enabled     = true
cluster-version            = "1.27"
cluster-name               = "gke-cluster"
enable-private-nodes       = true
enable-public-endpoint     = false
node_pool_name             = "gke-node-pool"
ondemand_machine_types     = ["e2-medium"]
preemptible_machine_types  = ["e2-standard-4", "e2-standard-2", "e2-medium"]
desired_capacity_ondemand  = 1
min_capacity_ondemand      = 1
max_capacity_ondemand      = 5
desired_capacity_preemptible = 1
min_capacity_preemptible   = 1
max_capacity_preemptible   = 10
addons = [
  {
    name    = "network-policy"
    version = "1.0"
  },
  {
    name    = "istio"
    version = "1.17"
  },
  {
    name    = "cloud-run"
    version = "latest"
  },
  # Add more addons as needed
]
