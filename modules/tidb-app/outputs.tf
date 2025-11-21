## modules/tidb-app/outputs.tf

output "tidb_status_cmd" {
  description = "Run this to view TiDB cluster pods"
  value       = "kubectl get pods -n tidb-cluster"
}
