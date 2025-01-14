# GCP-terraform

1. Networking Setup
Virtual Private Cloud (VPC)
Resource: google_compute_network.vpc
A custom VPC named dev-medium-dev-gke-vpc is created. This VPC will isolate network traffic and provide private networking for the GKE cluster and its components.
Subnets
Resource: google_compute_subnetwork.subnet
Three subnets (subnet-1, subnet-2, subnet-3) are created within the us-central1 region.
Each subnet has a unique CIDR block (10.0.0.0/20, 10.0.16.0/20, and 10.0.32.0/20).
Secondary IP ranges are defined for pods and services to allocate IP addresses dynamically for workloads:
Pods range: Allocated for Kubernetes Pods.
Services range: Allocated for Kubernetes Services.
Firewall Rules
Resource: google_compute_firewall.allow-internal
A firewall rule named dev-medium-dev-gke-vpc-allow-internal is created to allow internal traffic within the VPC on all TCP, UDP, and ICMP ports.
Cloud NAT
Resource: google_compute_router and google_compute_router_nat
A Cloud Router and NAT are created to allow outbound internet access for resources in private subnets without exposing them to the public internet.
2. Kubernetes Cluster
Primary GKE Cluster
Resource: google_container_cluster.primary
A GKE cluster named dev-medium-dev-gke-cluster is deployed:
Private Cluster: Nodes are private, and access to the master is restricted to the defined IP range (172.16.0.0/28).
Release Channel: The cluster is on the REGULAR release channel, which provides stable Kubernetes updates.
Deletion Protection: Enabled to prevent accidental deletion.
Master Authorized Networks: Allows all IPs (0.0.0.0/0) to access the master endpoint.
Shielded Nodes: Enabled for enhanced security.
Node Pools
Three separate node pools are created to optimize resource usage:

General Pool:
Machine Type: e2-standard-2 (2 vCPUs, 8 GB RAM).
Autoscaling: 1-5 nodes.
Memory Pool:
Machine Type: e2-highmem-4 (4 vCPUs, 32 GB RAM).
Disk Size: 200 GB.
Autoscaling: 1-5 nodes.
Spot Pool:
Machine Type: e2-standard-4 (4 vCPUs, 16 GB RAM).
Disk Size: 100 GB.
Spot Instances: These are preemptible, cost-effective VMs suitable for batch workloads or fault-tolerant applications.
Autoscaling: 0-10 nodes.
3. IAM and Service Accounts
Service Account
Resource: google_service_account.gke_sa
A dedicated service account is created for the GKE cluster with permissions for monitoring and logging.
IAM Roles
Resource: google_project_iam_member.gke_sa_roles
The service account is assigned roles:
roles/logging.logWriter
roles/monitoring.metricWriter
roles/monitoring.viewer
roles/stackdriver.resourceMetadata.writer
4. High-Level Architecture Overview
VPC:

Custom VPC isolates network traffic for the GKE cluster.
Subnets and firewall rules control internal communication and external internet access.
Cluster:

The GKE cluster runs workloads with multiple node pools tailored for general, memory-intensive, and cost-effective workloads (spot instances).
Networking:

Private cluster ensures security by restricting node access to private subnets.
Cloud NAT allows outbound internet access for updates and external communications.
Scalability:

Node pools are autoscaled to handle variable workloads efficiently.
Spot instances are used for cost savings.
Security:

Shielded nodes, private clusters, and IAM roles enhance security.
Deletion protection safeguards critical infrastructure.
