#####################################################
# VM Qemu Resource
#####################################################

variable "target_node" {
  description = "The name of the Proxmox Node on which to place the VM"
  type        = string
  default     = "pve"
}

variable "pool" {
  description = "The destination resource pool for the new VM"
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the VM within Proxmox"
  type        = string
}

variable "clone" {
  description = "The base VM from which to clone to create the new VM"
  type        = string
}

variable "sockets" {
  description = "The number of CPU sockets to allocate to the VM"
  type        = number
  default     = 1
}

variable "cores" {
  description = "The number of CPU cores per CPU socket to allocate to the VM"
  type        = number
  default     = 1
}

variable "numa" {
  description = "Whether to enable Non-Uniform Memory Access in the guest"
  type        = bool
  default     = false
}

variable "memory" {
  description = "The amount of memory to allocate to the VM in Megabytes"
  type        = number
  default     = 512
}

variable "disks" {
  description = "VM disk config"
  type        = list(object({}))
  default     = [{}]
}

variable "networks" {
  description = "VM network adapter config"
  type        = list(object({}))
  default     = [{}]
}

#####################################################
# Cloud-Init
#####################################################

variable "ciuser" {
  description = "Override the default cloud-init user for provisioning"
  type        = string
}

variable "cipassword" {
  description = "Override the default cloud-init user's password"
  type        = string
  sensitive   = true
  default     = null
}

variable "searchdomain" {
  description = "Sets default DNS search domain suffix"
  type        = string
  default     = null
}

variable "nameserver" {
  description = "Sets default DNS server for guest"
  type        = string
  default     = null
}

variable "sshkeys" {
  description = "Newline delimited list of SSH public keys to add to authorized keys file for the cloud-init user"
  type        = string
}

variable "ipconfig0" {
  description = "The first IP address to assign to the guest. Format: [gw=<GatewayIPv4>] [,gw6=<GatewayIPv6>] [,ip=<IPv4Format/CIDR>] [,ip6=<IPv6Format/CIDR>]"
  type        = string
  default     = "ip=dhcp"
}

variable "ipconfig1" {
  description = "The second IP address to assign to the guest. Same format as ipconfig0"
  type        = string
  default     = null
}

variable "ipconfig2" {
  description = "The third IP address to assign to the guest. Same format as ipconfig0"
  type        = string
  default     = null
}

#####################################################
# Other Vars
#####################################################

variable "connection" {
  description = "Provisioner connection settings"
  type        = object({})
  sensitive   = true
  default = {
    type  = "ssh"
    agent = true
  }
}

variable "ansible_groups" {
  description = "List of ansible groups to assign to the VM"
  type        = list(string)
  default     = ["all"]
}
