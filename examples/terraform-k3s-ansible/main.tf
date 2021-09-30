provider "proxmox" {
  pm_parallel     = 3
  pm_tls_insecure = true
  pm_api_url      = var.pm_api_url
  pm_user         = var.pm_user
  pm_password     = var.pm_password
}

module "k3s_server" {
  source = "../.."

  count = 1
  name  = "k3s-server-${count.index + 1}"

  target_node = "pve"
  pool        = "terraform"

  clone   = "ubuntu-2004-cloudinit-template"
  numa    = true
  sockets = 2
  memory  = 4096

  networks = [
    {
      bridge = "vmbr2"
    }
  ]

  ciuser  = "ubuntu"
  sshkeys = file("~/.ssh/id_ed25519.pub")

  ansible_groups = ["master"]
}

module "k3s_agent" {
  source = "../.."

  count = 1
  name  = "k3s-server-${count.index + 1}"

  target_node = "pve"
  pool        = "terraform"

  clone   = "ubuntu-2004-cloudinit-template"
  numa    = true
  sockets = 2
  memory  = 4096

  networks = [
    {
      bridge = "vmbr2"
    }
  ]

  disks = [
    {
      size = "50G"
    }
  ]

  ciuser  = "ubuntu"
  sshkeys = file("~/.ssh/id_ed25519.pub")

  ansible_groups = ["node"]
}
