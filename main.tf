## Root main.tf
## Calls the network, GKE cluster, and TiDB application modules.

# -----------------------------------------------------
# Module 1: Network Infrastructure
# -----------------------------------------------------
module "network" {
  source              = "./modules/network"
  region              = var.region
  vpc_name            = var.vpc_name
  subnet_name         = var.subnet_name
  ip_cidr_range       = var.ip_cidr_range
  pods_cidr_range     = var.pods_cidr_range
  services_cidr_range = var.services_cidr_range
}

# -----------------------------------------------------
# Module 2: GKE Cluster
# -----------------------------------------------------
module "gke_cluster" {
  source          = "./modules/gke-cluster"
  region          = var.region
  zone            = var.zone
  cluster_name    = var.cluster_name
  network_name    = module.network.vpc_name
  subnetwork_name = module.network.subnet_name
  
  pods_range_name     = module.network.pods_range_name
  services_range_name = module.network.services_range_name
  
  admin_count     = var.admin_count
  tidb_config     = {
    count        = var.tidb_count
    machine_type = var.tidb_machine_type
    disk_gb      = var.tidb_disk_gb
  }
  pd_config       = {
    count        = var.pd_count
    machine_type = var.pd_machine_type
    disk_gb      = var.pd_disk_gb
  }
  tikv_config     = {
    count        = var.tikv_count
    machine_type = var.tikv_machine_type
    disk_gb      = var.tikv_disk_gb
  }
  bignode_count = var.bignode_count

  depends_on = [module.network]
}




data "google_container_cluster" "primary" {
  name     = module.gke_cluster.gke_name
  location = var.region
  
  # Ensure the data source explicitly waits for the GKE cluster resource to be created.
  depends_on = [
    module.gke_cluster
  ]
}
# -----------------------------------------------------
# Module 3: TiDB Application Deployment
# -----------------------------------------------------

module "tidb_app" {
  source            = "./modules/tidb-app"
  tidb_cluster_yaml = file("./tidb-yamls/tidb-cluster.yaml") # Using file() instead of var.tidb_yaml_path/tidb-cluster.yaml
 
  # Explicitly pass the provider configuration to the module
  providers = {
    kubectl    = kubectl
    kubernetes = kubernetes
    helm       = helm
  }
  depends_on = [
    # Ensures the GKE cluster creation finishes before anything in this module starts
    module.gke_cluster 
  ]
}# Create Artifact Registry Repository (Must happen first)
resource "google_artifact_registry_repository" "destination_repo" {
  repository_id = var.artifact_registry_repo
  location      = var.ar_region  
  format        = "DOCKER"
  description   = "Docker image repository for mirroring dell-harbor.protecto.ai assets."
  project       = var.project_id
}

# -----------------------------------------------------
# Pull Images from Harbor (Source: dell-harbor.protecto.ai)
# -----------------------------------------------------
resource "docker_image" "private_apps" {
  for_each = var.application_images
  name = each.value # The Harbor address
  
  keep_locally = false
  pull_triggers = [
    timestamp()
  ]
}

# -----------------------------------------------------
# Tag Images for Artifact Registry (Rename)
# -----------------------------------------------------
resource "docker_tag" "registry_tags" {
  for_each = var.application_images
  
  # Source Image ID comes from the pull operation
  source_image = docker_image.private_apps[each.key].image_id
  
  # Target Image is the full AR path (Host/Project/Repo/Name:Tag)
  target_image = "${var.artifact_registry_host}/${var.project_id}/${var.artifact_registry_repo}/${each.key}:${split(":", each.value)[1]}"
  
  # Implicit dependency on docker_image.private_apps ensures pull completes before tagging starts
  depends_on = [docker_image.private_apps] 
}

# -----------------------------------------------------
# Push Images to Artifact Registry (Destination)
# -----------------------------------------------------
resource "docker_image" "artifact_pushes" {
  for_each = var.application_images
  
  # Name is the newly tagged AR path
  name = docker_tag.registry_tags[each.key].target_image

  # keep_locally = false triggers the implicit push
  keep_locally = false
  
  triggers = {
    digest = docker_image.private_apps[each.key].image_id
  }
  
  # CRITICAL DEPENDENCY: Ensure repository is created before attempting to push
  depends_on = [
    google_artifact_registry_repository.destination_repo 
  ]
}
