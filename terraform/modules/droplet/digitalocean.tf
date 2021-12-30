resource "digitalocean_droplet" "droplet" {
  image      = var.image
  name       = "${var.hostname}.${var.zone.zone}"
  region     = var.region
  size       = var.size
  backups    = var.backups
  monitoring = var.monitoring
  ipv6       = var.ipv6
  ssh_keys   = var.ssh_keys
  tags       = var.tags
  user_data  = var.user_data
}

output "droplet" {
  value = digitalocean_droplet.droplet
}
