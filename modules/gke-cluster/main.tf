## modules/gke-cluster/main.tf

# -------------------------
# GKE Cluster (Google Kubernetes Engine)
# Creates the regional GKE control plane.
# -------------------------
resource "google_container_cluster" "primary" {
  name                     = var.cluster_name
  location                 = var.region
  network                  = var.network_name
  subnetwork               = var.subnetwork_name

  remove_default_node_pool = true
  initial_node_count       = 1

  enable_shielded_nodes = true
  node_locations        = [var.zone]

  deletion_protection = false

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_range_name
    services_secondary_range_name = var.services_range_name
  }
}

# --- Node Pool: admin ---
resource "google_container_node_pool" "admin" {
  name       = "admin"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.admin_count

  node_config {
    machine_type = "e2-standard-2" # 2 CPU, 4GB RAM
    disk_size_gb = 50
  }

  depends_on = [google_container_cluster.primary]
}

# --- Node Pool: tidb ---
resource "google_container_node_pool" "tidb" {
  name       = "tidb"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.tidb_config.count

  node_config {
    machine_type = var.tidb_config.machine_type # e2-standard-4
    disk_size_gb = var.tidb_config.disk_gb      # 100

    labels = {
      dedicated = "tidb"
    }
    taint {
      key    = "dedicated"
      value  = "tidb"
      effect = "NO_SCHEDULE"
    }
  }

  depends_on = [google_container_cluster.primary]
}

# --- Node Pool: pd (Placement Driver) ---
resource "google_container_node_pool" "pd" {
  name       = "pd"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.pd_config.count

  node_config {
    machine_type = var.pd_config.machine_type # e2-standard-4
    disk_size_gb = var.pd_config.disk_gb      # 100

    labels = {
      dedicated = "pd"
    }
    taint {
      key    = "dedicated"
      value  = "pd"
      effect = "NO_SCHEDULE"
    }
  }

  depends_on = [google_container_cluster.primary]
}

# --- Node Pool: tikv (Key-Value Store) ---
resource "google_container_node_pool" "tikv" {
  name       = "tikv"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.tikv_config.count

  node_config {
    machine_type = var.tikv_config.machine_type # e2-standard-4
    disk_size_gb = var.tikv_config.disk_gb      # 250

    labels = {
      dedicated = "tikv"
    }
    taint {
      key    = "dedicated"
      value  = "tikv"
      effect = "NO_SCHEDULE"
    }
  }

  depends_on = [google_container_cluster.primary]
}

# --- Node Pool: bignode ---
resource "google_container_node_pool" "bignode" {
  name       = "bignode"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.bignode_count

  node_config {
    machine_type = "e2-standard-4" # 4 CPU, 16GB RAM
    disk_size_gb = 100
  }

  depends_on = [google_container_cluster.primary]
}
