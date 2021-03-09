terraform {
  required_version = ">= 0.14"

  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "~> 2.6.5"
    }

    ansible = {
      source  = "nbering/ansible"
      version = "~> 1.0.4"
    }
  }
}
