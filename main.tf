resource "proxmox_vm_qemu" "proxmox_vm" {
  target_node = var.target_node
  pool        = var.pool

  name  = var.name
  desc  = jsonencode(merge(var.tags, { groups = var.ansible_groups }))
  clone = var.clone

  sockets = var.sockets
  cores   = var.cores
  numa    = var.numa
  memory  = var.memory

  scsihw   = "virtio-scsi-pci"
  boot     = "c"
  bootdisk = "scsi0"

  agent = 1

  vga {
    type = "none"
  }

  serial {
    id   = 0
    type = "socket"
  }

  dynamic "disk" {
    for_each = var.disks
    content {
      type    = lookup(disk.value, "type", "scsi")
      storage = lookup(disk.value, "storage", "local-lvm")
      size    = lookup(disk.value, "size", "20G")
      discard = lookup(disk.value, "discard", null)
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
  ciuser       = var.ciuser
  cipassword   = var.cipassword
  searchdomain = var.searchdomain
  nameserver   = var.nameserver
  sshkeys      = var.sshkeys

  ipconfig0 = var.ipconfig0
  ipconfig1 = var.ipconfig1
  ipconfig2 = var.ipconfig2

  lifecycle {
    ignore_changes = [
      network,
      cipassword,
    ]
  }

  provisioner "remote-exec" {
    connection {
      type = try(var.connection.type, "ssh")

      host     = self.ssh_host
      user     = self.ciuser
      password = self.cipassword
      port     = try(var.connection.port, null)
      timeout  = try(var.connection.timeout, null)

      script_path    = try(var.connection.script_path, null)
      private_key    = try(var.connection.private_key, null)
      certificate    = try(var.connection.certificate, null)
      agent          = try(var.connection.agent, null)
      agent_identity = try(var.connection.agent_identity, null)
      host_key       = try(var.connection.host_key, null)

      https    = try(var.connection.https, null)
      insecure = try(var.connection.insecure, null)
      use_ntlm = try(var.connection.use_ntlm, null)
      cacert   = try(var.connection.cacert, null)

      bastion_host        = try(var.connection.bastion_host, null)
      bastion_host_key    = try(var.connection.bastion_host_key, null)
      bastion_port        = try(var.connection.bastion_port, null)
      bastion_user        = try(var.connection.bastion_user, null)
      bastion_password    = try(var.connection.bastion_password, null)
      bastion_private_key = try(var.connection.bastion_private_key, null)
      bastion_certificate = try(var.connection.bastion_certificate, null)
    }

    inline = [
      <<-EOT
      # --- use sudo if we are not already root ---
      [ $(id -u) -eq 0 ] || exec sudo -n $0 $@

      set -x

      # Apply netplan to update hostname on DHCP server
      netplan apply

      # Enable automatic login to serial console
      mkdir /usr/lib/systemd/system/serial-getty@ttyS0.service.d
      cat << 'EOF' > /usr/lib/systemd/system/serial-getty@ttyS0.service.d/override.conf
      [Service]
      ExecStart=
      ExecStart=-/sbin/agetty -a ${var.ciuser} --keep-baud 115200,38400,9600 %I $TERM
      EOF

      systemctl daemon-reload
      service serial-getty@ttyS0 restart
      EOT
    ]
  }
}
