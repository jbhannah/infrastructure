locals {
  minecraft_port = 25565
  rcon_port      = 25575
}

resource "digitalocean_project" "minecraft" {
  name        = "Minecraft"
  environment = "Production"
  purpose     = "Game Servers"

  resources = [
    module.mc_hannahs_family.droplet.urn,
  ]
}

resource "digitalocean_tag" "minecraft" {
  name = "minecraft"
}

resource "digitalocean_firewall" "minecraft" {
  name = "minecraft"
  tags = [digitalocean_tag.minecraft.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = local.minecraft_port
    source_addresses = [local.all_ipv4, local.all_ipv6]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = local.rcon_port
    source_addresses = [local.all_ipv4, local.all_ipv6]
  }
}

module "mc_hannahs_family" {
  source   = "./modules/minecraft"
  hostname = "mc"
  size     = "s-1vcpu-2gb-amd"
  zone     = cloudflare_zone.hannahs_family
  vpc      = module.vpc_default_sfo3
  ssh_keys = [digitalocean_ssh_key.infrastructure]

  tags = [
    digitalocean_tag.minecraft,
    digitalocean_tag.nginx,
    digitalocean_tag.ssh,
    digitalocean_tag.terraform
  ]
}
