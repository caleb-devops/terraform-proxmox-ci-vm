terraform {
  required_version = "~> 1.0"

  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "~> 2.6.5"
    }
  }
}
