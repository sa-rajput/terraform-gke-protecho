# versions.tf
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = { source = "hashicorp/google"  , version = "~> 7.11.0" }
    kubernetes = { source = "hashicorp/kubernetes" , version = "~> 2.38.0" }
    helm = { source = "hashicorp/helm" , version = "~> 3.1.0" }
    null = { source = "hashicorp/null" , version = "~> 3.2.4" }
    time = { source = "hashicorp/time" , version = "~> 0.13.1" }
    kubectl = { source = "gavinbunney/kubectl" , version = "~> 1.17" }
    http = { source = "hashicorp/http" , version = "~> 3.0" }
    local = { source = "hashicorp/local" , version = "~> 2.4" }
  }
}
