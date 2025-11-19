# provider.tf
# Google provider config. Keep credentials optional to allow ADC.

provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = var.credentials != "" ? file(var.credentials) : null
}

# Note: Kubernetes/helm/kubectl providers are configured in main.tf after cluster exists.
