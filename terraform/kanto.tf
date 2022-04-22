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

module "helm_kanto_external_dns" {
  source = "./modules/helm"
  providers = {
    helm = helm.kanto
  }

  name       = "external-dns"
  namespace  = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"

  values = <<-YAML
    env:
      - name: CF_API_TOKEN
        valueFrom:
          secretKeyRef:
            key: credential
            name: cloudflare-api
    podAnnotations:
      operator.1password.io/item-name: cloudflare-api
      operator.1password.io/item-path: vaults/wusn2jxjimwouyjyaqp654h7vq/items/lka26khjsd4f3kwukwcut7rq7a
    provider: cloudflare
    resources:
      requests:
        cpu: 10m
        memory: 32Mi
    sources:
      - service
      - ingress
      - crd
    txtOwnerId: kanto.external-dns
  YAML
}

module "helm_kanto_descheduler" {
  source = "./modules/helm"
  providers = {
    helm = helm.kanto
  }

  name       = "descheduler"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/descheduler"
  chart      = "descheduler"

  values = <<-YAML
    deschedulerPolicy:
      strategies:
        LowNodeUtilization:
          params:
            nodeResourceUtilizationThresholds:
              targetThresholds:
                cpu: 80
                memory: 80
                pods: 15
              thresholds:
                cpu: 60
                memory: 60
                pods: 5
    resources:
      requests:
        cpu: 50m
        memory: 64Mi
  YAML
}

module "helm_kanto_kube_state_metrics" {
  source = "./modules/helm"
  providers = {
    helm = helm.kanto
  }

  name       = "kube-state-metrics"
  namespace  = "kube-system"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-state-metrics"
}

module "helm_kanto_metrics_server" {
  source = "./modules/helm"
  providers = {
    helm = helm.kanto
  }

  name       = "metrics-server"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
}

module "helm_kanto_onepassword_connect" {
  source = "./modules/helm"
  providers = {
    helm = helm.kanto
  }

  name       = "onepassword-connect"
  namespace  = "onepassword"
  repository = "https://1password.github.io/connect-helm-charts"
  chart      = "connect"

  values = <<-YAML
    connect:
      serviceType: ClusterIP
    operator:
      autoRestart: true
      create: true
  YAML
}

module "helm_kanto_oauth2_proxy" {
  source = "./modules/helm"
  providers = {
    helm = helm.kanto
  }

  name       = "oauth2-proxy"
  namespace  = "traefik"
  repository = "https://oauth2-proxy.github.io/manifests"
  chart      = "oauth2-proxy"

  values = <<-YAML
    config:
      configFile: |-
        cookie_domains = [
          ".hannahs.family",
          ".jbhannah.net"
        ]
        email_domains = ["*"]
        github_org = "hannahs-family"
        github_team = ""
        provider = "github"
        redirect_url = "https://auth.hannahs.family/oauth2/callback"
        reverse_proxy = true
        set_authorization_header = true
        set_xauthrequest = true
        upstreams = [
          "static://202"
        ]
        whitelist_domains = [
          ".hannahs.family",
          ".jbhannah.net"
        ]
      existingSecret: oauth2-proxy
    ingress:
      enabled: false
    podAnnotations:
      operator.1password.io/item-name: oauth2-proxy
      operator.1password.io/item-path: vaults/wusn2jxjimwouyjyaqp654h7vq/items/mevlkheef2vvcgcrdxq2ynhrjq
    securityContext:
      enabled: true
  YAML
}

module "helm_kanto_traefik" {
  source = "./modules/helm"
  providers = {
    helm = helm.kanto
  }

  name       = "traefik"
  namespace  = "traefik"
  repository = "https://helm.traefik.io/traefik"
  chart      = "traefik"

  values = <<-YAML
    additionalArguments:
      - --api
      - --providers.kubernetesingress.ingressendpoint.hostname=www.hannahs.family
      - --entrypoints.web.proxyprotocol
      - --entrypoints.web.proxyprotocol.trustedips=10.0.0.0/8
      - --entrypoints.web.forwardedheaders
      - --entrypoints.web.forwardedheaders.trustedips=10.0.0.0/8
      - --entrypoints.websecure.proxyprotocol
      - --entrypoints.websecure.proxyprotocol.trustedips=10.0.0.0/8
      - --entrypoints.websecure.forwardedheaders
      - --entrypoints.websecure.forwardedheaders.trustedips=10.0.0.0/8
    affinity:
      podAntiAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchExpressions:
                - key: app.kubernetes.io/name
                  operator: In
                  values:
                    - traefik
            topologyKey: kubernetes.io/hostname
    deployment:
      replicas: 2
    experimental:
      plugins:
        enabled: true
    ingressClass:
      enabled: true
      isDefaultClass: true
    ingressRoute:
      dashboard:
        enabled: false
    logs:
      general:
        level: INFO
    pilot:
      dashboard: true
      enabled: true
      token: f9339a9d-27bb-4dbe-a26d-10396526d4c8
    podDisruptionBudget:
      enabled: true
      minAvailable: 1
    podSecurityPolicy:
      enabled: true
    ports:
      web:
        redirectTo: websecure
      websecure:
        tls:
          enabled: true
    providers:
      kubernetesCRD:
        enabled: true
      kubernetesIngress:
        enabled: true
    resources:
      limits:
        cpu: 300m
        memory: 150Mi
      requests:
        cpu: 100m
        memory: 50Mi
    service:
      annotations:
        external-dns.alpha.kubernetes.io/hostname: www.hannahs.family
  YAML
}
