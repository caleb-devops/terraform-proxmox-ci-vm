resource "proxmox_vm_qemu" "proxmox_vm" {
  target_node = var.target_node
  pool = var.pm_pool

  name = var.vm_name
  clone = var.vm_template

  sockets = var.sockets
  cores = var.cores
  numa = var.numa
  memory = var.memory
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
      type         = lookup(disk.value, "type", "scsi")
      storage      = lookup(disk.value, "storage", "local-lvm")
      size         = lookup(disk.value, "size", "20G")
      discard      = lookup(disk.value, "discard", null)
    }
  }

  dynamic "network" {
    for_each = var.networks
    content {
      model  = lookup(network.value, "model", "virtio")
      bridge = lookup(network.value, "bridge", "vmbr0")
      tag    = lookup(network.value, "vlan", -1)
    }
  }

  os_type = "cloud-init"

  # Cloud-Init Settings
  ipconfig0 = var.ipconfig0
  ipconfig1 = var.ipconfig1
  ipconfig2 = var.ipconfig2

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

  provisioner "remote-exec" {
    inline = [
      "sudo netplan apply",
      "sudo sed -i 's|-o \\x27-p -- \\\\\\\\u\\x27|-a ${var.ciuser}|' /lib/systemd/system/serial-getty@.service",
      "sudo systemctl daemon-reload",
      "sudo service serial-getty@ttyS0 restart"
    ]

    connection {
      type        = "ssh"
      user        = var.ciuser
      private_key = file(var.private_key_path)
      host        = self.ssh_host
    }
  }
}

resource "ansible_host" "proxmox_vm" {
  inventory_hostname = proxmox_vm_qemu.proxmox_vm.name
  groups = var.ansible_groups
  vars = {
    ansible_host = proxmox_vm_qemu.proxmox_vm.ssh_host
    ansible_user = var.ciuser
  }
}