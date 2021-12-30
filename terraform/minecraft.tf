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

resource "digitalocean_droplet" "mc_hannahs_family" {
  image      = "ubuntu-20-04-x64"
  name       = "mc.hannahs.family"
  region     = "sfo3"
  size       = "s-1vcpu-2gb"
  backups    = true
  monitoring = true
  ipv6       = true
  ssh_keys   = [digitalocean_ssh_key.infrastructure.fingerprint]
  tags = [
    digitalocean_tag.minecraft.id,
    digitalocean_tag.ssh.id,
    digitalocean_tag.terraform.id,
  ]

  user_data = <<-YAML
    #cloud-config

    packages:
      - openjdk-17-jre-headless
      - tmux

    users:
      - name: minecraft
        homedir: /opt/minecraft
        system: true
  YAML
}

resource "cloudflare_record" "mc_hannahs_family_A" {
  zone_id = cloudflare_zone.hannahs_family.id
  name    = "mc"
  type    = "A"
  value   = digitalocean_droplet.mc_hannahs_family.ipv4_address
}

resource "cloudflare_record" "mc_hannahs_family_AAAA" {
  zone_id = cloudflare_zone.hannahs_family.id
  name    = "mc"
  type    = "AAAA"
  value   = digitalocean_droplet.mc_hannahs_family.ipv6_address
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
    target   = digitalocean_droplet.mc_hannahs_family.name
  }
}
