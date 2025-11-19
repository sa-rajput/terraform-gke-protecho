resource "google_container_node_pool" "admin" {
  name       = "admin"
  location   = var.region
  cluster    = var.cluster_name
  node_count = var.admin_count

  node_config {
    machine_type = var.admin_machine_type
    disk_size_gb = var.admin_disk_gb
  }
}

resource "google_container_node_pool" "tidb" {
  name       = "tidb"
  location   = var.region
  cluster    = var.cluster_name
  node_count = var.tidb_count

  node_config {
    machine_type = var.tidb_machine_type
    disk_size_gb = var.tidb_disk_gb
    labels = { dedicated = "tidb" }

    taint {
      key    = "dedicated"
      value  = "tidb"
      effect = "NO_SCHEDULE"
    }
  }

  depends_on = [google_container_node_pool.admin]
}

resource "google_container_node_pool" "pd" {
  name       = "pd"
  location   = var.region
  cluster    = var.cluster_name
  node_count = var.pd_count

  node_config {
    machine_type = var.pd_machine_type
    disk_size_gb = var.pd_disk_gb
    labels = { dedicated = "pd" }

    taint {
      key    = "dedicated"
      value  = "pd"
      effect = "NO_SCHEDULE"
    }
  }
}

resource "google_container_node_pool" "tikv" {
  name       = "tikv"
  location   = var.region
  cluster    = var.cluster_name
  node_count = var.tikv_count

  node_config {
    machine_type = var.tikv_machine_type
    disk_size_gb = var.tikv_disk_gb
    labels = { dedicated = "tikv" }

    taint {
      key    = "dedicated"
      value  = "tikv"
      effect = "NO_SCHEDULE"
    }
  }
}

resource "google_container_node_pool" "bignode" {
  name       = "bignode"
  location   = var.region
  cluster    = var.cluster_name
  node_count = var.bignode_count

  node_config {
    machine_type = var.bignode_machine_type
    disk_size_gb = var.bignode_disk_gb
  }
}
