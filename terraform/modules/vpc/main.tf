terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "name" {
  type    = string
  default = "default"
}

variable "region" {
  type    = string
  default = "sfo3"
}
