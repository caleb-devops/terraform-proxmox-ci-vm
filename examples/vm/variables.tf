#####################################################
# Proxmox Settings
#####################################################

variable "pm_api_url" {
  description = "The Proxmox API URL"
  type        = string
}

variable "pm_user" {
  description = "The Proxmox username"
  type        = string
}

variable "pm_password" {
  description = "The Proxmox password"
  type        = string
}
