# modules/tidb-app/main.tf
#
# Manages Kubernetes resources for TiDB deployment.

# -------------------------
# Kubernetes Namespace
# Creates a namespace dedicated for the TiDB cluster.
# -------------------------
resource "kubernetes_namespace" "tidb_cluster" {
  metadata {
    name = "tidb-cluster"
  }
}

# ------------------------------------------
# 1. Fetch TiDB Operator CRDs (Multi-Document YAML)
# Uses data.http to fetch content at runtime.
# ------------------------------------------
data "http" "tidb_crd" {
  url = "https://raw.githubusercontent.com/pingcap/tidb-operator/v1.6.0/manifests/crd.yaml"
}

# ------------------------------------------
# 2. Split multi-document YAML into a list
# The content (crd_docs) is UNKNOWN during the plan phase.
# ------------------------------------------
locals {
  # Split CRDs by YAML document separator '---'
  crd_docs = [
    for doc in split("\n---", data.http.tidb_crd.response_body) :
    trimspace(doc)
    if trimspace(doc) != ""
  ]
}

# ------------------------------------------
# 3. Apply each CRD via kubectl_manifest (FIXED for Plan Phase)
# We use 'count' (plan-time safe) instead of 'for_each' (requires known keys).
# ------------------------------------------
resource "kubectl_manifest" "tidb_crds" {
  # We assume there are max 10 CRDs (a safe upper limit for the CRD file)
  count             = 10 
  
  # The YAML body is resolved during the APPLY phase using element().
  # If count.index is too high, it uses an empty string ("").
  yaml_body         = count.index < length(local.crd_docs) ? element(local.crd_docs, count.index) : ""
  
  server_side_apply = true
  wait              = true

  # Precondition ensures we only try to create valid CRDs, skipping the empty strings.
  lifecycle {
    precondition {
      condition     = count.index < length(local.crd_docs)
      error_message = "Skipping null CRD index outside the actual document range."
    }
  }
}

# -------------------------
# TiDB Operator Deployment (Helm)
# -------------------------
resource "helm_release" "tidb_operator" {
  depends_on = [
    # Depends on the CRDs being applied
    kubectl_manifest.tidb_crds
  ]

  name             = "tidb-operator"
  namespace        = "tidb-admin"
  create_namespace = true

  repository = "https://charts.pingcap.org/"
  chart      = "tidb-operator"
  version    = "v1.6.0"
}

# -------------------------
# TiDB Cluster Deployment (kubectl_manifest)
# -------------------------
resource "kubectl_manifest" "tidb_cluster" {
  yaml_body         = var.tidb_cluster_yaml # Use the passed-in file content (tidb-cluster.yaml)
  server_side_apply = true
  wait              = true

  depends_on = [
    kubernetes_namespace.tidb_cluster,
    helm_release.tidb_operator # Operator must be running before the cluster CR is applied
  ]
}
