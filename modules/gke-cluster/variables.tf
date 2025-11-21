## modules/gke-cluster/variables.tf

variable "region" {
  description = "GCP region for the GKE cluster"
  type        = string
}

variable "zone" {
  description = "GCP zone for node placement"
  type        = string
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "network_name" {
  description = "VPC network name"
  type        = string
}

variable "subnetwork_name" {
  description = "Subnetwork name"
  type        = string
}

variable "pods_range_name" {
  description = "Secondary IP range name for Pods"
  type        = string
}

variable "services_range_name" {
  description = "Secondary IP range name for Services"
  type        = string
}

# --- Node Pool Variables ---
variable "admin_count" {
  description = "Number of nodes in the 'admin' pool"
  type        = number
}

variable "bignode_count" {
  description = "Number of nodes in the 'bignode' pool"
  type        = number
}

variable "tidb_config" {
  description = "Configuration for the tidb node pool"
  type = object({
    count        = number
    machine_type = string
    disk_gb      = number
  })
}

variable "pd_config" {
  description = "Configuration for the pd node pool"
  type = object({
    count        = number
    machine_type = string
    disk_gb      = number
  })
}

variable "tikv_config" {
  description = "Configuration for the tikv node pool"
  type = object({
    count        = number
    machine_type = string
    disk_gb      = number
  })
}
