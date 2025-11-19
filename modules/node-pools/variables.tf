variable "cluster_name" { type = string }
variable "region" { type = string }
variable "zone" { type = string }

# admin
variable "admin_machine_type" { type = string, default = "e2-standard-2" }
variable "admin_disk_gb" { type = number, default = 50 }
variable "admin_count" { type = number, default = 1 }

# tidb
variable "tidb_machine_type" { type = string, default = "e2-standard-4" }
variable "tidb_disk_gb" { type = number, default = 100 }
variable "tidb_count" { type = number, default = 1 }

# pd
variable "pd_machine_type" { type = string, default = "e2-standard-4" }
variable "pd_disk_gb" { type = number, default = 100 }
variable "pd_count" { type = number, default = 1 }

# tikv
variable "tikv_machine_type" { type = string, default = "e2-standard-4" }
variable "tikv_disk_gb" { type = number, default = 250 }
variable "tikv_count" { type = number, default = 1 }

# bignode
variable "bignode_machine_type" { type = string, default = "e2-standard-4" }
variable "bignode_disk_gb" { type = number, default = 100 }
variable "bignode_count" { type = number, default = 5 }
