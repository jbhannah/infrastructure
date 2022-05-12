locals {
  minecraft_port = 25565
  rcon_port      = 25575

  packages = [
    "certbot",
    "nginx",
    "python3-certbot-nginx"
  ]

  runcmd = [
    "ufw allow http",
    "ufw allow https",
    "certbot -n --nginx -d mc.hannahs.family --agree-tos --email admin@hannahs.family --redirect",
  ]
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
  source         = "./modules/minecraft"
  hostname       = "mc"
  size           = "s-2vcpu-4gb-amd"
  minecraft_port = local.minecraft_port
  rcon_port      = local.rcon_port
  zone           = cloudflare_zone.hannahs_family
  vpc            = module.vpc_default_sfo3
  ssh_keys       = [digitalocean_ssh_key.infrastructure]
  packages       = local.packages
  runcmd         = local.runcmd

  tags = [
    digitalocean_tag.minecraft,
    digitalocean_tag.nginx,
    digitalocean_tag.ssh,
    digitalocean_tag.terraform,
  ]
}

module "mc_jbhannah_net" {
  source         = "./modules/minecraft.v2"
  hostname       = "mc"
  size           = "s-1vcpu-2gb-amd"
  minecraft_port = local.minecraft_port
  rcon_port      = local.rcon_port
  zone           = cloudflare_zone.jbhannah_net
  vpc            = module.vpc_default_sfo3
  ssh_keys       = [digitalocean_ssh_key.infrastructure]

  tags = [
    digitalocean_tag.minecraft,
    digitalocean_tag.nginx,
    digitalocean_tag.ssh,
    digitalocean_tag.terraform,
  ]
}
