resource "cloudflare_zone" "bolderbrooklyn_tv" {
  zone = "bolderbrooklyn.tv"
}

resource "cloudflare_zone_dnssec" "bolderbrooklyn_tv" {
  zone_id = cloudflare_zone.bolderbrooklyn_tv.id
}

resource "digitalocean_project" "bolderbrooklyn_tv" {
  name        = "bolderbrooklyn.tv"
  environment = "Production"
  purpose     = "Game Servers"

  resources = [
    module.mc_bolderbrooklyn_tv.droplet.urn,
  ]
}

module "mc_bolderbrooklyn_tv" {
  source   = "./modules/minecraft.v2"
  hostname = "mc"
  size     = "s-1vcpu-2gb-amd"
  zone     = cloudflare_zone.bolderbrooklyn_tv
  vpc      = module.vpc_default_sfo3
  ssh_keys = [digitalocean_ssh_key.infrastructure]

  tags = [
    digitalocean_tag.minecraft,
    digitalocean_tag.nginx,
    digitalocean_tag.ssh,
    digitalocean_tag.terraform
  ]
}
