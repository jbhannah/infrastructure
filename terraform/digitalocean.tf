locals {
  all_ipv4 = "0.0.0.0/0"
  all_ipv6 = "::/0"
}

resource "digitalocean_tag" "terraform" {
  name = "terraform"
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
}

resource "digitalocean_ssh_key" "infrastructure" {
  name       = "Infrastructure"
  public_key = file("../.ssh/id_ed25519.infra.pub")
}
