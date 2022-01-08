resource "digitalocean_droplet" "droplet" {
  image             = var.image
  name              = "${var.hostname}.${var.zone.zone}"
  region            = var.vpc.region
  vpc_uuid          = var.vpc.vpc.id
  size              = var.size
  backups           = var.backups
  monitoring        = var.monitoring
  ipv6              = var.ipv6
  graceful_shutdown = var.graceful_shutdown
  ssh_keys          = var.ssh_keys
  tags              = concat(var.tags[*].id, [var.vpc.tag.id])
  user_data         = var.user_data
}

output "droplet" {
  value = digitalocean_droplet.droplet
}
