locals {
  minecraft_port = 25565
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
}

module "mc_hannahs_family" {
  source         = "./modules/minecraft"
  hostname       = "mc"
  minecraft_port = local.minecraft_port
  zone           = cloudflare_zone.hannahs_family
  vpc            = module.vpc_sfo3
  ssh_keys       = [digitalocean_ssh_key.infrastructure.fingerprint]
  tags = [
    digitalocean_tag.minecraft,
    digitalocean_tag.nginx,
    digitalocean_tag.ssh,
    digitalocean_tag.terraform,
  ]
}

module "creative_mc_hannahs_family" {
  source         = "./modules/minecraft"
  hostname       = "creative.mc"
  minecraft_port = local.minecraft_port
  zone           = cloudflare_zone.hannahs_family
  vpc            = module.vpc_sfo3
  ssh_keys       = [digitalocean_ssh_key.infrastructure.fingerprint]
  tags = [
    digitalocean_tag.minecraft,
    digitalocean_tag.nginx,
    digitalocean_tag.ssh,
    digitalocean_tag.terraform,
  ]
}
