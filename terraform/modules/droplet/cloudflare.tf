resource "cloudflare_record" "dns_A" {
  zone_id = var.zone.id
  name    = var.hostname
  type    = "A"
  value   = digitalocean_droplet.droplet.ipv4_address
}

resource "cloudflare_record" "dns_AAAA" {
  count   = var.ipv6 ? 1 : 0
  zone_id = var.zone.id
  name    = var.hostname
  type    = "AAAA"
  value   = digitalocean_droplet.droplet.ipv6_address
}

output "dns_A" {
  value = cloudflare_record.dns_A
}

output "dns_AAAA" {
  value = var.ipv6 ? cloudflare_record.dns_AAAA[0] : null
}
