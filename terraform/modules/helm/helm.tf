resource "helm_release" "helm_release" {
  name       = var.name
  namespace  = var.namespace
  chart      = var.chart
  repository = var.repository
  version    = var.chart_version
  values     = [var.values]
}
