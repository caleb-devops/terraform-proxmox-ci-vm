provider "proxmox" {
  pm_parallel = 2
  pm_tls_insecure = true
  pm_api_url = var.pm_api_url
  pm_user = var.pm_user
  pm_password = var.pm_password
}

module "k3s-master" {
  source = "../"

  vm_name = "k3s-master"
  vm_num = 1

  sockets = 2
  memory = 4096

  networks = [
    {
      bridge = "vmbr2"
    }
  ]

  ansible_groups = ["master"]
}

module "k3s-node" {
  source = "./"

  vm_name = "k3s-node"
  vm_num = 2

  sockets = 2
  memory = 4096

  networks = [
    {
      bridge = "vmbr2"
    }
  ]

  ansible_groups = ["node"]
}

resource "ansible_group" "k3s_cluster" {
  inventory_group_name = "k3s_cluster"
  children = ["master", "node"]
}