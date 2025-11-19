output "node_pools" {
  value = [
    google_container_node_pool.admin.name,
    google_container_node_pool.tidb.name,
    google_container_node_pool.pd.name,
    google_container_node_pool.tikv.name,
    google_container_node_pool.bignode.name,
  ]
}
