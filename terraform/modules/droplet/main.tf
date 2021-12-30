terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }

    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "image" {
  type    = string
  default = "ubuntu-20-04-x64"
}

variable "hostname" {
  type        = string
  description = "Hostname without base domain"
}

variable "zone" {
  type = object({
    id   = string
    zone = string
  })
  description = "Cloudflare zone of base domain"
}

variable "region" {
  type    = string
  default = "sfo3"
}

variable "size" {
  type    = string
  default = "s-1vcpu-2gb"
}

variable "backups" {
  type    = bool
  default = true
}

variable "monitoring" {
  type    = bool
  default = true
}

variable "ipv6" {
  type    = bool
  default = true
}

variable "graceful_shutdown" {
  type    = bool
  default = true
}

variable "ssh_keys" {
  type    = list(string)
  default = []
}

variable "tags" {
  type    = list(string)
  default = []
}

variable "user_data" {
  type    = string
  default = null
}
