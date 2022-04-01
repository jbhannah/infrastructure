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
