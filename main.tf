resource "proxmox_vm_qemu" "proxmox_vm" {
  count = var.vm_num

  target_node = var.target_node
  pool = var.pm_pool

  name = format("%s-%d", var.vm_name, count.index+1)
  clone = var.vm_template

  sockets = var.sockets
  cores = var.cores
  memory = var.memory
  numa = true
  scsihw = "virtio-scsi-pci"
  boot = "c"
  bootdisk = "scsi0"
  agent = 1

  vga {
    type = "none"
  }

  serial {
    id = 0
    type = "socket"
  }

  dynamic "disk" {
    for_each = var.disks
    content {
      id           = lookup(disk.value, "id", disk.key)
      type         = lookup(disk.value, "type", "scsi")
      storage      = lookup(disk.value, "storage", "local-lvm")
      storage_type = lookup(disk.value, "storage_type", "lvm")
      size         = lookup(disk.value, "size", 20)
    }
  }

  dynamic "network" {
    for_each = var.networks
    content {
      id     = lookup(network.value, "id", network.key)
      model  = lookup(network.value, "model", "virtio")
      bridge = lookup(network.value, "bridge", "vmbr0")
      tag    = lookup(network.value, "vlan", -1)
    }
  }

  os_type = "cloud-init"

  # Cloud-Init Settings
  ipconfig0 = var.ipconfig0 == null ? null : var.ipconfig0.ip == "dhcp" ? "ip=dhcp" : join(",", 
    compact([
      format("ip=%s/%s",
        cidrhost(var.ipconfig0.ip, regex("(\\d+)\\.(\\d+)\\.(\\d+)\\.(\\d+)/(\\d+)", var.ipconfig0.ip)[3] + count.index),
        split("/", var.ipconfig0.ip)[1]
      ),
      contains(keys(var.ipconfig0), "gw") == false ? "" : format("gw=%s", var.ipconfig0.gw)
    ])
  )

  ipconfig1 = var.ipconfig1 == null ? null : var.ipconfig1.ip == "dhcp" ? "ip=dhcp" : join(",", 
    compact([
      format("ip=%s/%s",
        cidrhost(var.ipconfig1.ip, regex("(\\d+)\\.(\\d+)\\.(\\d+)\\.(\\d+)/(\\d+)", var.ipconfig1.ip)[3] + count.index),
        split("/", var.ipconfig1.ip)[1]
      ),
      contains(keys(var.ipconfig1), "gw") == false ? "" : format("gw=%s", var.ipconfig1.gw)
    ])
  )

  ipconfig2 = var.ipconfig2 == null ? null : var.ipconfig2.ip == "dhcp" ? "ip=dhcp" : join(",", 
    compact([
      format("ip=%s/%s",
        cidrhost(var.ipconfig2.ip, regex("(\\d+)\\.(\\d+)\\.(\\d+)\\.(\\d+)/(\\d+)", var.ipconfig2.ip)[3] + count.index),
        split("/", var.ipconfig2.ip)[1]
      ),
      contains(keys(var.ipconfig2), "gw") == false ? "" : format("gw=%s", var.ipconfig2.gw)
    ])
  )

  nameserver = var.nameserver
  searchdomain = var.searchdomain
  sshkeys = file(var.public_key_path)
  ciuser = var.ciuser
  cipassword = var.cipass

  lifecycle {
    ignore_changes = [
      network,
      cipassword,
    ]
  }
}

resource "ansible_host" "proxmox_vm" {
  count = length(proxmox_vm_qemu.proxmox_vm)
  inventory_hostname = proxmox_vm_qemu.proxmox_vm[count.index].name
  groups = var.ansible_groups
  vars = {
    ansible_host = proxmox_vm_qemu.proxmox_vm[count.index].ssh_host
    ansible_user = var.ciuser
  }
}