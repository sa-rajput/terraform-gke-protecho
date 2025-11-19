output "gke_endpoint" { value = module.gke.endpoint }
output "gke_cluster_name" { value = module.gke.name }
output "network_self_link" { value = module.networking.network_self_link }
output "subnet_self_link" { value = module.networking.subnet_self_link }
