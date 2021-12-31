locals {
  minecraft_port = 25565

  user_data = <<-YAML
    #cloud-config

    package_upgrade: true
    package_reboot_if_required: true

    packages:
      - openjdk-17-jre-headless
      - tmux

    runcmd:
      - ufw limit ssh
      - ufw allow 25565
      - ufw enable

    users:
      - name: minecraft
        homedir: /opt/minecraft
        shell: /bin/bash
        system: true
  YAML
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
  source   = "./modules/droplet"
  hostname = "mc"
  zone     = cloudflare_zone.hannahs_family
  ssh_keys = [digitalocean_ssh_key.infrastructure.fingerprint]
  tags = [
    digitalocean_tag.minecraft.id,
    digitalocean_tag.ssh.id,
    digitalocean_tag.terraform.id,
  ]
  user_data = local.user_data
}

resource "cloudflare_record" "mc_hannahs_family_SRV_minecraft_tcp" {
  zone_id = cloudflare_zone.hannahs_family.id
  name    = "_minecraft._tcp.mc"
  type    = "SRV"

  data {
    service  = "_minecraft"
    proto    = "_tcp"
    name     = "minecraft"
    priority = 0
    weight   = 0
    port     = local.minecraft_port
    target   = module.mc_hannahs_family.droplet.name
  }
}

module "creative_mc_hannahs_family" {
  source   = "./modules/droplet"
  hostname = "creative.mc"
  zone     = cloudflare_zone.hannahs_family
  ssh_keys = [digitalocean_ssh_key.infrastructure.fingerprint]
  tags = [
    digitalocean_tag.minecraft.id,
    digitalocean_tag.ssh.id,
    digitalocean_tag.terraform.id,
  ]
  user_data = local.user_data
}

resource "cloudflare_record" "creative_mc_hannahs_family_SRV_minecraft_tcp" {
  zone_id = cloudflare_zone.hannahs_family.id
  name    = "_minecraft._tcp.creative.mc"
  type    = "SRV"

  data {
    service  = "_minecraft"
    proto    = "_tcp"
    name     = "minecraft"
    priority = 0
    weight   = 0
    port     = local.minecraft_port
    target   = module.creative_mc_hannahs_family.droplet.name
  }
}
