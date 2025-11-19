variable "project_id" { type = string }
variable "region" { type = string }
variable "zone" { type = string }
variable "cluster_name" { type = string, default = "protecho-gke" }
variable "network_name" { type = string }
variable "subnetwork_name" { type = string }
