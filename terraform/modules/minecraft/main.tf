terraform {
  experiments = [module_variable_optional_attrs]

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

variable "minecraft_port" {
  type    = number
  default = 25565
}

variable "rcon_port" {
  type    = number
  default = 25575
}

variable "vpc" {
  type = object({
    region = string
    vpc = object({
      id = string
    })
    tag = object({
      id = string
    })
  })
  description = "DigitalOcean VPC of droplet"
}

variable "backups" {
  type    = bool
  default = true
}

variable "graceful_shutdown" {
  type    = bool
  default = true
}

variable "ipv6" {
  type    = bool
  default = true
}

variable "monitoring" {
  type    = bool
  default = true
}

variable "proxied" {
  type    = bool
  default = false
}

variable "size" {
  type    = string
  default = "s-1vcpu-2gb"
}

variable "ssh_keys" {
  type = list(object({
    public_key = string
  }))
  default = []
}

variable "tags" {
  type = list(object({
    id = string
  }))
  default = []
}

variable "package_upgrade" {
  type    = bool
  default = true
}

variable "package_reboot_if_required" {
  type    = bool
  default = true
}

variable "packages" {
  type    = list(string)
  default = []
}

variable "runcmd" {
  type    = list(string)
  default = []
}

variable "users" {
  type = list(object({
    name                = string
    homedir             = optional(string)
    ssh_authorized_keys = optional(list(string))
    sudo                = optional(list(string))
    groups              = optional(list(string))
    shell               = optional(string)
    system              = optional(bool)
  }))

  default = []
}

variable "write_files" {
  type = list(object({
    path    = string
    content = string
  }))

  default = []
}
