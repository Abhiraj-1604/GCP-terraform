# GKE Architecture Deployment

This repository contains Terraform configurations to deploy a **Google Kubernetes Engine (GKE)** cluster on **Google Cloud Platform (GCP)**. Below is an overview of the architecture and the deployment setup.

---

## Architecture Overview

### Key Components:

1. **Virtual Private Cloud (VPC):**
   - A custom VPC named `dev-medium-dev-gke-vpc` isolates network traffic for the GKE cluster.
   - Three subnets are created within the `us-central1` region:
     - Subnet 1: `10.0.0.0/20`
     - Subnet 2: `10.0.16.0/20`
     - Subnet 3: `10.0.32.0/20`

2. **GKE Cluster:**
   - **Private Cluster**: Nodes are deployed in private subnets with restricted access to the master.
   - **Node Pools**:
     - General Pool: `e2-standard-2` (2 vCPUs, 8 GB RAM), autoscaled 1-5 nodes.
     - Memory Pool: `e2-highmem-4` (4 vCPUs, 32 GB RAM), autoscaled 1-5 nodes.
     - Spot Pool: `e2-standard-4` (4 vCPUs, 16 GB RAM), autoscaled 0-10 nodes (uses spot instances for cost optimization).

3. **Networking:**
   - **Firewall Rule**: Allows internal communication within the VPC.
   - **Cloud NAT**: Provides outbound internet access for private nodes through a Cloud Router.

4. **IAM and Security:**
   - A dedicated service account is created for the GKE cluster.
   - Roles are assigned for logging and monitoring.

---

## Deployment Steps

### 1. Prerequisites:
- Terraform installed.
- GCP project with necessary permissions.
- `gcloud` CLI authenticated to the target project.

### 2. Clone the Repository:
```bash
git clone <repository-url>
cd <repository-folder>
````

### 3. Update Variables:
Modify the variables.tf file or provide a terraform.tfvars file with the required values.

### 4. Initialize Terraform:
```
terraform init
```
### 5. Plan the Deployment:
```
terraform plan
```

### 6. Apply the Deployment:
```
terraform apply
```

## Notes
-Private Cluster: This setup ensures enhanced security by keeping nodes in private subnets and using Cloud NAT for internet access.
-Autoscaling: Node pools are autoscaled to handle varying workloads efficiently.
-Spot Instances: Used in the Spot Pool for cost-effective, fault-tolerant workloads.
