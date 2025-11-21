# modules/tidb-app/versions.tf

terraform {
  required_providers {
    # Explicitly state the provider alias and its source for this module.
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.17"
    }
  }
}
