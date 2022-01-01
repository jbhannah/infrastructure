locals {
  all_ipv4 = "0.0.0.0/0"
  all_ipv6 = "::/0"

  email_alerts = ["jesse+alerts@jbhannah.net"]
}

resource "digitalocean_tag" "terraform" {
  name = "terraform"
}

resource "digitalocean_firewall" "allow_dns_outbound" {
  name = "allow-dns-outbound"
  tags = [digitalocean_tag.terraform.id]

  outbound_rule {
    protocol              = "tcp"
    port_range            = "53"
    destination_addresses = [local.all_ipv4, local.all_ipv6]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "53"
    destination_addresses = [local.all_ipv4, local.all_ipv6]
  }
}

resource "digitalocean_firewall" "allow_http_outbound" {
  name = "allow-http-outbound"
  tags = [digitalocean_tag.terraform.id]

  outbound_rule {
    protocol              = "tcp"
    port_range            = "80"
    destination_addresses = [local.all_ipv4, local.all_ipv6]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "443"
    destination_addresses = [local.all_ipv4, local.all_ipv6]
  }
}

resource "digitalocean_monitor_alert" "cpu_alert" {
  alerts {
    email = local.email_alerts
  }

  window      = "10m"
  type        = "v1/insights/droplet/cpu"
  compare     = "GreaterThan"
  value       = 70
  enabled     = true
  tags        = [digitalocean_tag.terraform.id]
  description = "CPU is running high"
}

resource "digitalocean_monitor_alert" "memory_utilization_percent_alert" {
  alerts {
    email = local.email_alerts
  }

  window      = "10m"
  type        = "v1/insights/droplet/memory_utilization_percent"
  compare     = "GreaterThan"
  value       = 90
  enabled     = true
  tags        = [digitalocean_tag.terraform.id]
  description = "Memory usage is running high"
}

resource "digitalocean_monitor_alert" "disk_read_alert" {
  alerts {
    email = local.email_alerts
  }

  window      = "5m"
  type        = "v1/insights/droplet/disk_read"
  compare     = "GreaterThan"
  value       = 1
  enabled     = true
  tags        = [digitalocean_tag.terraform.id]
  description = "Disk read is running high"
}

resource "digitalocean_monitor_alert" "disk_write_alert" {
  alerts {
    email = local.email_alerts
  }

  window      = "5m"
  type        = "v1/insights/droplet/disk_write"
  compare     = "GreaterThan"
  value       = 1
  enabled     = true
  tags        = [digitalocean_tag.terraform.id]
  description = "Disk write is running high"
}

resource "digitalocean_monitor_alert" "disk_utilization_percent_alert" {
  alerts {
    email = local.email_alerts
  }

  window      = "5m"
  type        = "v1/insights/droplet/disk_utilization_percent"
  compare     = "GreaterThan"
  value       = 85
  enabled     = true
  tags        = [digitalocean_tag.terraform.id]
  description = "Disk usage is running high"
}

resource "digitalocean_tag" "ssh" {
  name = "ssh"
}

resource "digitalocean_firewall" "ssh" {
  name = "ssh"
  tags = [digitalocean_tag.ssh.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = [local.all_ipv4, local.all_ipv6]
  }

  outbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    destination_tags = [digitalocean_tag.ssh.id]
  }
}

resource "digitalocean_ssh_key" "infrastructure" {
  name       = "Infrastructure"
  public_key = file("../.ssh/id_ed25519.infra.pub")
}
