resource "cloudflare_record" "SRV_minecraft_tcp" {
  zone_id = var.zone.id
  name    = "_minecraft._tcp.${var.hostname}"
  type    = "SRV"

  data {
    service  = "_minecraft"
    proto    = "_tcp"
    name     = var.hostname
    priority = 0
    weight   = 0
    port     = var.minecraft_port
    target   = module.droplet.droplet.name
  }
}
