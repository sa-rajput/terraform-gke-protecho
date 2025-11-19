provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = var.credentials != "" ? file(var.credentials) : null
}

# kubernetes/helm/kubectl providers are configured where appropriate (see modules/gke-cluster notes).
