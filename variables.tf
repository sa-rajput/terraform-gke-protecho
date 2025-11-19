# variables.tf (root)
# Global inputs and feature flags

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "zone" {
  description = "GCP zone"
  type        = string
}

variable "credentials" {
  description = "Path to GCP credentials JSON (optional; ADC used if empty)"
  type        = string
  default     = ""
}

variable "enable_tidb" {
  description = "If true, deploy TiDB (CRDs, operator, cluster)"
  type        = bool
  default     = false
}

variable "tidb_yaml_path" {
  description = "Relative path to tidb-cluster.yaml inside modules/tidb"
  type        = string
  default     = "./modules/tidb/tidb-cluster.yaml"
}
