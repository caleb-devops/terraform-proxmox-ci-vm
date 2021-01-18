variable "target_node" {
  description = "Node to place the VM on"
  type = string
  default = "pve"
}

variable "pm_pool" {
  description = "The destination resource pool for the new VM"
  type = string
  default = "terraform"
}

variable "vm_template" {
  description = "Name of virtual machine to clone"
  type = string
  default = "ubuntu-2004-cloudinit-template"
}

variable "vm_name" {
  description = "The name of the virtual machine"
  type = string
}

variable "sockets" {
  description = "The number of CPU sockets"
  type = number
  default = 1
}

variable "cores" {
  description = "The number of cores per socket"
  type = number
  default = 1
}

variable "numa" {
  description = "Enable/disable NUMA"
  type = bool
  default = false
}

variable "memory" {
  description = "Amount of RAM for the VM in MB"
  type = number
  default = 512
}

variable "disks" {
  description = "VM disk config"
  type = list(map(string))
  default = [{}]
}

variable "networks" {
  description = "VM network adapter config"
  type = list(map(string))
  default = [{}]
}

#####################################################
# Cloud-Init Settings
#####################################################

variable "ipconfig0" {
  description = "Cloud-init specific, [gw=] [,gw6=] [,ip=<IPv4Format/CIDR>] [,ip6=<IPv6Format/CIDR>]"
  type = string
  default = "ip=dhcp"
}

variable "ipconfig1" {
  description = "Cloud-init specific, [gw=] [,gw6=] [,ip=<IPv4Format/CIDR>] [,ip6=<IPv6Format/CIDR>]"
  type = string
  default = null
}

variable "ipconfig2" {
  description = "Cloud-init specific, [gw=] [,gw6=] [,ip=<IPv4Format/CIDR>] [,ip6=<IPv6Format/CIDR>]"
  type = string
  default = null
}

variable "nameserver" {
  description = "DNS server IP"
  type = string
  default = null
}

variable "searchdomain" {
  description = "DNS search domain"
  type = string
  default = null
}

variable "ciuser" {
  description = "User name to change ssh keys and password"
  type = string
  default = "ubuntu"
}

variable "cipass" {
  description = "Password to assign the user"
  type = string
  default = null
}

variable "public_key_path" {
  description = "Path to the ssh public key"
  type = string
  default = "~/.ssh/id_ed25519.pub"
}

variable "private_key_path" {
  description = "Path to the ssh private key"
  type = string
  default = "~/.ssh/id_ed25519"
}

variable "ansible_groups" {
  description = "List of ansible groups to assign to the VM"
  type = list(string)
  default = ["all"]
}