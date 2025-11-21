## Root provider.tf
## Configures the required providers and the Google provider authentication.

terraform {
  required_providers {
    # Kubernetes provider
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38.0"
    }
    # Helm provider
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.1.0"
    }
    # kubectl provider
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.17"
    }
    # http data source
    http = {
      source = "hashicorp/http"
      version = "~> 3.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = var.credentials != "" ? file(var.credentials) : null
}

# -----------------------------------------------------
# 🔗 GKE/AR Access Token Retrieval (Stable Method)
# -----------------------------------------------------
# This uses the external program to reliably fetch the Gcloud OAuth token.
data "external" "gcloud_token" {
  program = [
    "bash", "-c",
    "token=$(gcloud auth print-access-token 2>/dev/null) && printf '%s' \"{\\\"access_token\\\":\\\"$token\\\"}\""
  ]
}

# -----------------------------------------------------
# Provider configurations (Using stable token for all K8s providers)
# -----------------------------------------------------

# 🗑️ REMOVED: data "google_client_config" "default" {}

provider "kubernetes" {
  host                     = "https://${data.google_container_cluster.primary.endpoint}"
  
  # ✅ FIX: Use the robust external token for GKE
  token                    = data.external.gcloud_token.result["access_token"] 
  
  cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
}

provider "kubectl" {
  host                     = "https://${data.google_container_cluster.primary.endpoint}"
  
  # ✅ FIX: Use the robust external token for Kubectl
  token                    = data.external.gcloud_token.result["access_token"] 
  
  cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
  load_config_file         = false
}

provider "helm" {
  kubernetes = {
    host                     = "https://${data.google_container_cluster.primary.endpoint}"
    
    # ✅ FIX: Use the robust external token for Helm
    token                    = data.external.gcloud_token.result["access_token"] 
    
    cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
  }
}

# -----------------------------------------------------
# 🐳 Docker Provider (Authentication)
# -----------------------------------------------------

provider "docker" {
  
  # 1. Auth for Harbor (Private Registry)
  registry_auth {
    address  = var.private_registry_address
    username = data.google_secret_manager_secret_version.docker_username_read.secret_data
    password = data.google_secret_manager_secret_version.docker_password_read.secret_data
  }

  # 2. Auth for TARGET registry (Artifact Registry)
  registry_auth {
    address  = var.artifact_registry_host
    username = "oauth2accesstoken"
    # Uses the same reliable external token
    password = data.external.gcloud_token.result["access_token"] 
  }
}
