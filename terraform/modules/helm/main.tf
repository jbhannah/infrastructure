terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

variable "name" {
  type        = string
  description = "Release name"
}

variable "namespace" {
  type        = string
  description = "Release namespace"
}

variable "chart" {
  type        = string
  description = "Chart name"
}

variable "repository" {
  type        = string
  description = "Repository URL"
}

variable "devel" {
  type        = bool
  description = "Allow development versions"
  default     = false
}

variable "chart_version" {
  type        = string
  description = "Chart version"
  default     = null
}

variable "values" {
  type        = string
  description = "Chart values"
  default     = null
}
