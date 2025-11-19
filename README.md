# terraform-gke-protecho

Module-based Terraform for GKE + TiDB (structure required by architect).

## Layout
Top-level files:
- main.tf
- variables.tf
- outputs.tf
- provider.tf
- versions.tf
- terraform.tfvars (example)
- .gitignore

Modules:
- modules/networking
- modules/gke-cluster
- modules/node-pools
- modules/tidb

## Quick start
1. Copy the repository to a folder.
2. Put your Google credentials JSON somewhere safe (and update `terraform.tfvars`).
3. Edit `terraform.tfvars` to set `project_id`, `region`, `zone`.
4. (Optional) Toggle `enable_tidb = true` if you want the TiDB module to run.

Commands:
```bash
terraform init
terraform plan
terraform apply
