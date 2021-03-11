provider "proxmox" {
  pm_parallel     = 3
  pm_tls_insecure = true
  pm_api_url      = var.pm_api_url
  pm_user         = var.pm_user
  pm_password     = var.pm_password
}

module "ubuntu_vm" {
  source = "../.."

  count = 1
  name  = "ubuntu-${count.index + 1}"

  target_node = "pve"
  pool        = "terraform"

  clone   = "ubuntu-2004-cloudinit-template"
  numa    = true
  sockets = 2
  memory  = 2048

  networks = [
    {
      bridge = "vmbr2"
    }
  ]

  ciuser  = "ubuntu"
  sshkeys = file("~/.ssh/id_ed25519.pub")

  ansible_groups = ["master"]
}
