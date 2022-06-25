module "droplet" {
  source            = "../droplet"
  image             = var.image
  hostname          = var.hostname
  zone              = var.zone
  vpc               = var.vpc
  size              = var.size
  backups           = var.backups
  monitoring        = var.monitoring
  ipv6              = var.ipv6
  graceful_shutdown = var.graceful_shutdown
  ssh_keys          = var.ssh_keys
  tags              = var.tags
}

output "droplet" {
  value = module.droplet.droplet
}
