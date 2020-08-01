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
  description = "Name of VM"
  type = string
}

variable "vm_num" {
  description = "Number of VMs to deploy"
  type = number
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
  description = <<-EOT
    Specify IP addresses and gateways for the corresponding interface. IP address will auto increment for each VM.
    ip=<IPv4Format/CIDR> (default = dhcp)
      IPv4 address in CIDR format.
    gw=<GatewayIPv4>
      Default gateway for IPv4 traffic.
  EOT
  type = map(string)
  default = {
    ip = "dhcp"
  }
}

variable "ipconfig1" {
  description = <<-EOT
    Specify IP addresses and gateways for the corresponding interface. IP address will auto increment for each VM.
    ip=<IPv4Format/CIDR> (default = dhcp)
      IPv4 address in CIDR format.
    gw=<GatewayIPv4>
      Default gateway for IPv4 traffic.
  EOT
  type = map(string)
  default = null
}

variable "ipconfig2" {
  description = <<-EOT
    Specify IP addresses and gateways for the corresponding interface. IP address will auto increment for each VM.
    ip=<IPv4Format/CIDR> (default = dhcp)
      IPv4 address in CIDR format.
    gw=<GatewayIPv4>
      Default gateway for IPv4 traffic.
  EOT
  type = map(string)
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

variable "ansible_groups" {
  description = "List of ansible groups to assign to the VM"
  type = list(string)
  default = ["all"]
}