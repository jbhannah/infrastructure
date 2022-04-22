resource "digitalocean_tag" "kanto" {
  name = "kanto"
}

resource "digitalocean_tag" "pallet" {
  name = "pallet"
}

resource "digitalocean_vpc" "kanto" {
  name   = "kanto"
  region = "sfo3"
}

data "digitalocean_kubernetes_versions" "v1_22" {
  version_prefix = "1.22"
}

resource "digitalocean_kubernetes_cluster" "kanto" {
  name     = "kanto"
  region   = "sfo3"
  vpc_uuid = digitalocean_vpc.kanto.id

  auto_upgrade = true
  version      = data.digitalocean_kubernetes_versions.v1_22.latest_version

  tags = [digitalocean_tag.kanto.name]

  node_pool {
    name       = "pallet"
    size       = "s-1vcpu-2gb"
    node_count = 3

    tags = [
      digitalocean_tag.kanto.name,
      digitalocean_tag.pallet.name,
    ]
  }
}

provider "helm" {
  alias = "kanto"

  kubernetes {
    host                   = digitalocean_kubernetes_cluster.kanto.endpoint
    cluster_ca_certificate = base64decode(digitalocean_kubernetes_cluster.kanto.kube_config[0].cluster_ca_certificate)
    token                  = digitalocean_kubernetes_cluster.kanto.kube_config[0].token
  }
}

module "helm_kanto_cert_manager" {
  source = "./modules/helm"
  providers = {
    helm = helm.kanto
  }

  name       = "cert-manager"
  namespace  = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  values = <<-YAML
    cainjector:
      resources:
        requests:
          cpu: 10m
          memory: 32Mi
    deploymentAnnotations:
      operator.1password.io/item-name: cloudflare-api
      operator.1password.io/item-path: vaults/wusn2jxjimwouyjyaqp654h7vq/items/lka26khjsd4f3kwukwcut7rq7a
    global:
      leaderElection:
        namespace: cert-manager
      podSecurityPolicy:
        enabled: true
    ingressShim:
      defaultIssuerGroup: cert-manager.io
      defaultIssuerKind: ClusterIssuer
      defaultIssuerName: letsencrypt-prod
    installCRDs: true
    resources:
      requests:
        cpu: 10m
        memory: 32Mi
    webhook:
      resources:
        requests:
          cpu: 10m
          memory: 32Mi
  YAML
}
