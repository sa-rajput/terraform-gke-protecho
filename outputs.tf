## Root outputs.tf
## Exposes essential information from the sub-modules.

# -----------------------------
# VPC & Subnet Details
# -----------------------------
output "vpc_details" {
  description = "VPC network details"
  value       = module.network.vpc_details
}

output "subnet_details" {
  description = "Subnet details (with secondary ranges for Pods/Services)"
  value       = module.network.subnet_details
}

# -----------------------------
# GKE Cluster Details
# -----------------------------
output "gke_cluster_details" {
  description = "GKE cluster details"
  value       = module.gke_cluster.gke_cluster_details
}

output "all_node_pool_names" {
  description = "List of all node pool names deployed"
  value       = module.gke_cluster.all_node_pool_names
}

output "gke_endpoint" {
  description = "The public endpoint of the GKE master API server."
  value       = module.gke_cluster.gke_endpoint
}

# -----------------------------
# TiDB Application Details
# -----------------------------
output "tidb_status_cmd" {
  description = "Run this to view TiDB cluster pods"
  value       =   module.tidb_app.tidb_status_cmd
}

output "pulled_image_ids" {
  description = "IDs of all successfully pulled application images."
  value = {
    for key, image in docker_image.private_apps : key => image.image_id
  }
}
