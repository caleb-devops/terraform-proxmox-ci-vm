#####################################################
# Proxmox Settings
#####################################################

variable "pm_api_url" {
  type = string
}

variable "pm_user" {
  type = string
}

variable "pm_password" {
  type = string
}

#####################################################
# VM Settings
#####################################################

variable "private_key_path" {
  type = string
  default = "~/.ssh/id_ed25519"
}