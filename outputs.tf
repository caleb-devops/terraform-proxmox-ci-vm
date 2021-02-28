output "vmid" {
  description = "The ID of the VM in Proxmox"
  value       = proxmox_vm_qemu.proxmox_vm.vmid
}

output "hostname" {
  description = "The hostname of the VM"
  value       = proxmox_vm_qemu.proxmox_vm.name
}

output "ip" {
  description = "The IP address of the VM"
  value       = proxmox_vm_qemu.proxmox_vm.ssh_host
}

output "username" {
  description = "The username of the VM"
  value       = proxmox_vm_qemu.proxmox_vm.ciuser
}

output "groups" {
  description = "The Ansible groups assigned to the VM"
  value       = ansible_host.proxmox_vm.groups
}
