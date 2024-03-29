locals {
  user_data = {
    package_upgrade            = true
    package_reboot_if_required = true

    packages = []

    runcmd = [
      "ufw limit ssh",
      "ufw enable",
    ]

    users = [
      {
        name                = "infrastructure"
        ssh_authorized_keys = var.ssh_keys[*].public_key
        sudo                = ["ALL=(ALL) NOPASSWD:ALL"]
        groups              = ["sudo"]
        shell               = "/bin/bash"
      }
    ]

    write_files = [
      {
        path    = "/etc/ssh/sshd_config.d/00-defaults.conf"
        content = <<-EOF
          PermitRootLogin no
          PasswordAuthentication no
          AllowUsers infrastructure
        EOF
      }
    ]
  }
}

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
  tags              = concat(var.tags[*].id, [var.vpc.tag.id])
  user_data         = <<-YAML
    #cloud-config

    ${yamlencode(local.user_data)}
  YAML
}

output "droplet" {
  value = digitalocean_droplet.droplet
}

output "user_data" {
  value = <<-YAML
    #cloud-config

    ${yamlencode(local.user_data)}
  YAML
}
