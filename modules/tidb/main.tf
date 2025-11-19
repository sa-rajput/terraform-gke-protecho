data "http" "tidb_crd" {
  url = "https://raw.githubusercontent.com/pingcap/tidb-operator/v1.6.0/manifests/crd.yaml"
}

locals {
  crd_docs = [ for doc in split("\n---", data.http.tidb_crd.response_body) : trimspace(doc) if trimspace(doc) != "" ]
}

resource "kubectl_manifest" "tidb_crds" {
  for_each = { for idx, v in local.crd_docs : idx => v }
  yaml_body         = each.value
  server_side_apply = true
  wait              = true
}

resource "helm_release" "tidb_operator" {
  name       = "tidb-operator"
  namespace  = "tidb-admin"
  create_namespace = true
  repository = "https://charts.pingcap.org/"
  chart      = "tidb-operator"
  version    = "v1.6.0"

  depends_on = [kubectl_manifest.tidb_crds]
}

resource "kubectl_manifest" "tidb_cluster" {
  yaml_body         = file(var.tidb_yaml_path)
  server_side_apply = true
  wait              = true

  depends_on = [helm_release.tidb_operator]
}
