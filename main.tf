# main.tf
# Root orchestrator: wires modules together. Keep logic minimal here:
# - Calls modules (networking, gke-cluster, node-pools, tidb)
# - Configures Kubernetes/Helm/Kubectl providers after cluster creation
# Note: Modules live in ./modules/*

module "networking" {
  source = "./modules/networking"

  project_id         = var.project_id
  region             = var.region
  zone               = var.zone

  network_name       = "protecho-network"
  subnet_name        = "protecho-network-subnet"
  ip_cidr_range      = "10.0.0.0/16"
  pods_cidr_range    = "10.20.0.0/20"
  services_cidr_range = "10.24.0.0/20"
}

module "gke" {
  source = "./modules/gke-cluster"

  project_id  = var.project_id
  region      = var.region
  zone        = var.zone

  # wire network/subnet from networking module outputs
  network     = module.networking.network_self_link
  subnetwork  = module.networking.subnet_self_link

  cluster_name = "protecho-gke"
}

module "node_pools" {
  source = "./modules/node-pools"

  project_id   = var.project_id
  region       = var.region
  zone         = var.zone
  cluster_name = module.gke.cluster_name
}

# TiDB module is optional; controlled by enable_tidb
module "tidb" {
  source = "./modules/tidb"
  count  = var.enable_tidb ? 1 : 0

  project_id     = var.project_id
  region         = var.region
  zone           = var.zone
  cluster_name   = module.gke.cluster_name
  tidb_yaml_path = var.tidb_yaml_path

  depends_on = [module.gke]
}

# After cluster creation, configure providers that need cluster endpoint/CA:
data "google_client_config" "default" {}

data "google_container_cluster" "gke" {
  name     = module.gke.cluster_name
  location = var.region
  depends_on = [module.gke]
}

provider "kubernetes" {
  host = "https://${data.google_container_cluster.gke.endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.gke.master_auth[0].cluster_ca_certificate)
  load_config_file = false
}

provider "kubectl" {
  host = "https://${data.google_container_cluster.gke.endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.gke.master_auth[0].cluster_ca_certificate)
  load_config_file = false
}

provider "helm" {
  kubernetes = {
    host = "https://${data.google_container_cluster.gke.endpoint}"
    token = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(data.google_container_cluster.gke.master_auth[0].cluster_ca_certificate)
  }
}
