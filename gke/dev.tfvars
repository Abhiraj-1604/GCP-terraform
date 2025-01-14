project_id         = "civic-gate-439511-j2"
region            = "us-central1"
vpc-name          = "dev-gke-vpc"
subnet-name       = "dev-gke-subnet"
subnet-count      = 3
subnet-cidr-blocks = [
  "10.0.0.0/20",   # Primary subnet in us-central1-a
  "10.0.16.0/20",  # Primary subnet in us-central1-b
  "10.0.32.0/20"   # Primary subnet in us-central1-c
]
pod-cidr-blocks    = [
  "10.48.0.0/14",  # Pod range for subnet 1
  "10.52.0.0/14",  # Pod range for subnet 2
  "10.56.0.0/14"   # Pod range for subnet 3
]
svc-cidr-blocks    = [
  "10.60.0.0/20",  # Service range for subnet 1
  "10.60.16.0/20", # Service range for subnet 2
  "10.60.32.0/20"  # Service range for subnet 3
]
cluster-name      = "dev-gke-cluster"
cluster-version   = "1.27.3-gke.100"

node_pools = [
  {
    name         = "general-pool"
    machine_type = "e2-standard-2"
    min_count    = 1
    max_count    = 5
    disk_size_gb = 100
    spot         = false
  },
  {
    name         = "spot-pool"
    machine_type = "e2-standard-4"
    min_count    = 0
    max_count    = 10
    disk_size_gb = 100
    spot         = true
  },
  {
    name         = "memory-pool"
    machine_type = "e2-highmem-4"
    min_count    = 1
    max_count    = 5
    disk_size_gb = 200
    spot         = false
  }
]
