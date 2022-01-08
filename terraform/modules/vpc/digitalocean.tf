resource "digitalocean_vpc" "vpc" {
  name   = "${var.name}-${var.region}"
  region = var.region
}

resource "digitalocean_tag" "tag" {
  name = digitalocean_vpc.vpc.name
}

resource "digitalocean_firewall" "allow_private" {
  name = "allow-private-${digitalocean_vpc.vpc.name}"
  tags = [digitalocean_tag.tag.id]

  inbound_rule {
    protocol    = "tcp"
    port_range  = "1-65535"
    source_tags = [digitalocean_tag.tag.id]
  }

  inbound_rule {
    protocol    = "udp"
    port_range  = "1-65535"
    source_tags = [digitalocean_tag.tag.id]
  }

  inbound_rule {
    protocol    = "icmp"
    source_tags = [digitalocean_tag.tag.id]
  }

  outbound_rule {
    protocol         = "tcp"
    port_range       = "1-65535"
    destination_tags = [digitalocean_tag.tag.id]
  }

  outbound_rule {
    protocol         = "udp"
    port_range       = "1-65535"
    destination_tags = [digitalocean_tag.tag.id]
  }

  outbound_rule {
    protocol         = "icmp"
    destination_tags = [digitalocean_tag.tag.id]
  }
}

output "allow_private" {
  value = digitalocean_firewall.allow_private
}

output "region" {
  value = var.region
}

output "tag" {
  value = digitalocean_tag.tag
}

output "vpc" {
  value = digitalocean_vpc.vpc
}
