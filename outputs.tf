# outputs.tf (root)
# Root-level conveniences that aggregate module outputs

output "vpc_name" {
  description = "VPC name from networking module"
  value       = module.networking.network_name
}

output "subnet_self_link" {
  description = "Subnet self_link"
  value       = module.networking.subnet_self_link
}

output "gke_cluster_name" {
  description = "GKE cluster name"
  value       = module.gke.cluster_name
}

output "gke_endpoint" {
  description = "GKE endpoint (control plane)"
  value       = module.gke.endpoint
}

output "all_node_pool_names" {
  description = "List of node pool names"
  value       = module.node_pools.node_pool_names
}
