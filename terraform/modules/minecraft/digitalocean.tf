locals {
  packages = [
    "openjdk-17-jre-headless",
    "tmux",
  ]

  runcmd = [
    "ufw allow ${var.minecraft_port}",
    "ufw allow ${var.rcon_port}",
  ]

  users = [
    {
      name    = "minecraft"
      homedir = "/opt/minecraft"
      shell   = "/bin/bash"
      system  = true
    }
  ]
}

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

  package_upgrade            = var.package_upgrade
  package_reboot_if_required = var.package_reboot_if_required
  packages                   = concat(local.packages, var.packages)
  runcmd                     = concat(local.runcmd, var.runcmd)
  users                      = concat(local.users, var.users)
  write_files                = var.write_files
}

output "droplet" {
  value = module.droplet.droplet
}

output "user_data" {
  value = module.droplet.user_data
}
