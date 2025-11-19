variable "project_id" { type = string }
variable "region" { type = string }
variable "zone" { type = string }

variable "network_name" { type = string, default = "protecho-network" }
variable "subnet_name" { type = string, default = "protecho-network-subnet" }
variable "ip_cidr_range" { type = string, default = "10.0.0.0/16" }
variable "pods_cidr_range" { type = string, default = "10.20.0.0/20" }
variable "services_cidr_range" { type = string, default = "10.24.0.0/20" }
