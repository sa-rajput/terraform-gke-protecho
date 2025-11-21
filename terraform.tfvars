## -----------------------------------------------------
## 1. Global / Project Configuration
## -----------------------------------------------------

project_id  = "protecto-public" # Replace with your actual production Project ID
region      = "asia-south1"          # Mumbai region
zone        = "asia-south1-a"

# Optional: Set this if you are using a Service Account Key file
# Otherwise, leave it blank to use Application Default Credentials (recommended for CI/CD)
credentials = "" # e.g., "key.json"

## -----------------------------------------------------
## 2. Network Variables
## -----------------------------------------------------

vpc_name              = "protecho-network-prod"
subnet_name           = "protecho-subnet-prod"
ip_cidr_range         = "10.0.0.0/16"  # GKE Nodes
pods_cidr_range       = "10.20.0.0/20" # GKE Pods (Secondary Range 1)
services_cidr_range   = "10.24.0.0/20" # GKE Services (Secondary Range 2)

## -----------------------------------------------------
## 3. GKE Cluster Variables
## -----------------------------------------------------

cluster_name = "protecho-gke-prod"

## -----------------------------------------------------
## 4. Node Pool Configuration (Based on original main.tf)
## -----------------------------------------------------

# --- admin (e2-standard-2, 50GB Disk) ---
admin_count = 1

# --- bignode (e2-standard-4, 100GB Disk) ---
bignode_count = 5

# --- tidb (e2-standard-4, 100GB Disk) ---
tidb_count        = 1
tidb_machine_type = "e2-standard-4"
tidb_disk_gb      = 100

# --- pd (e2-standard-4, 100GB Disk) ---
pd_count          = 1
pd_machine_type   = "e2-standard-4"
pd_disk_gb        = 100

# --- tikv (e2-standard-4, 250GB Disk) ---
tikv_count        = 1
tikv_machine_type = "e2-standard-4"
tikv_disk_gb      = 250

# The username (Robot Account) for dell-harbor.protecto.ai
robot_username = "robot$gcp-marketplace"

# The password/token for the robot account
robot_password = "qgXVHbBfTk5qBCrHnKxVePUeW6bKhBDD"

# The registry address (used for reference, usually doesn't need changing)
private_registry_address = "dell-harbor.protecto.ai"



application_images = {
  # Key = internal Terraform identifier; Value = Full Registry Path
  "async_request_batch_job"            = "dell-harbor.protecto.ai/gcp-marketplace/async_request_batch_job:v8.0.0-prod",
  "privacy_vault_backend_service"      = "dell-harbor.protecto.ai/gcp-marketplace/privacy_vault_backend_service:v8.0.0-prod",
  "privacy_vault_token_pre_gen_job"    = "dell-harbor.protecto.ai/gcp-marketplace/privacy_vault_token_pre_gen_job:v8.0.0-prod",
#  "ml-service-large"                   = "dell-harbor.protecto.ai/gcp-marketplace/ml-service-large:v8.0.0-prod",
  "rabbitmq"                           = "dell-harbor.protecto.ai/gcp-marketplace/rabbitmq:3.8.22-management-alpine",
}

artifact_registry_host = "asia-south1-docker.pkg.dev"
artifact_registry_repo = "gcp-marketplace-mirror"
ar_region              = "asia-south1" # <-- NEW VALUE
