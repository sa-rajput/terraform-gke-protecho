## modules/gke-cluster/outputs.tf

output "gke_name" {
  description = "The name of the GKE cluster"
  value       = google_container_cluster.primary.name
}

output "gke_endpoint" {
  description = "The public endpoint of the GKE master API server."
  value       = google_container_cluster.primary.endpoint
}

output "gke_cluster_details" {
  description = "GKE cluster details"
  value = {
    name     = google_container_cluster.primary.name
    location = google_container_cluster.primary.location
    endpoint = google_container_cluster.primary.endpoint
    network  = google_container_cluster.primary.network
    master_version = google_container_cluster.primary.master_version
  }
}

output "all_node_pool_names" {
  description = "List of all node pool names deployed"
  value = [
    google_container_node_pool.admin.name,
    google_container_node_pool.tidb.name,
    google_container_node_pool.pd.name,
    google_container_node_pool.tikv.name,
    google_container_node_pool.bignode.name,
  ]
}
