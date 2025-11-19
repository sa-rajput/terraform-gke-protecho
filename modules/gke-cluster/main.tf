resource "google_container_cluster" "primary" {
  name                 = var.cluster_name
  location             = var.region
  network              = var.network_name
  subnetwork           = var.subnetwork_name

  remove_default_node_pool = true
  initial_node_count       = 1

  enable_shielded_nodes = true
  node_locations        = [var.zone]

  deletion_protection = false

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }
}

data "google_client_config" "default" {}

data "google_container_cluster" "primary_ds" {
  name     = google_container_cluster.primary.name
  location = var.region
  depends_on = [google_container_cluster.primary]
}

output "endpoint" { value = google_container_cluster.primary.endpoint }
output "name" { value = google_container_cluster.primary.name }
