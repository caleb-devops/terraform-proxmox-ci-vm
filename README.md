# terraform-proxmox-ci-vm

Terraform module which creates Proxmox Cloud-Init VMs and adds them to an Ansible dynamic inventory.

<https://github.com/nbering/terraform-inventory/>

## Proxmox VM Template Requirements

The Proxmox VM template must be cloud-init enabled and have `qemu-guest-agent` installed.

`qemu-guest-agent` can be added to an existing cloud image using [create_template.sh](scripts/create_template.sh).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14 |
| ansible | ~> 1.0.4 |
| proxmox | ~> 2.6.5 |

## Providers

| Name | Version |
|------|---------|
| ansible | ~> 1.0.4 |
| proxmox | ~> 2.6.5 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [ansible_host](https://registry.terraform.io/providers/nbering/ansible/latest/docs/resources/host) |
| [proxmox_vm_qemu](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/vm_qemu) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ansible\_groups | List of ansible groups to assign to the VM | `list(string)` | <pre>[<br>  "all"<br>]</pre> | no |
| cipassword | Override the default cloud-init user's password | `string` | `null` | no |
| ciuser | Override the default cloud-init user for provisioning | `string` | n/a | yes |
| clone | The base VM from which to clone to create the new VM | `string` | n/a | yes |
| connection | Provisioner connection settings | `map(string)` | <pre>{<br>  "agent": true,<br>  "type": "ssh"<br>}</pre> | no |
| cores | The number of CPU cores per CPU socket to allocate to the VM | `number` | `1` | no |
| disks | VM disk config | `list(map(string))` | <pre>[<br>  {}<br>]</pre> | no |
| ipconfig0 | The first IP address to assign to the guest. Format: [gw=<GatewayIPv4>] [,gw6=<GatewayIPv6>] [,ip=<IPv4Format/CIDR>] [,ip6=<IPv6Format/CIDR>] | `string` | `"ip=dhcp"` | no |
| ipconfig1 | The second IP address to assign to the guest. Same format as ipconfig0 | `string` | `null` | no |
| ipconfig2 | The third IP address to assign to the guest. Same format as ipconfig0 | `string` | `null` | no |
| memory | The amount of memory to allocate to the VM in Megabytes | `number` | `512` | no |
| name | The name of the VM within Proxmox | `string` | n/a | yes |
| nameserver | Sets default DNS server for guest | `string` | `null` | no |
| networks | VM network adapter config | `list(map(string))` | <pre>[<br>  {}<br>]</pre> | no |
| numa | Whether to enable Non-Uniform Memory Access in the guest | `bool` | `false` | no |
| pool | The destination resource pool for the new VM | `string` | `null` | no |
| searchdomain | Sets default DNS search domain suffix | `string` | `null` | no |
| sockets | The number of CPU sockets to allocate to the VM | `number` | `1` | no |
| sshkeys | Newline delimited list of SSH public keys to add to authorized keys file for the cloud-init user | `string` | n/a | yes |
| target\_node | The name of the Proxmox Node on which to place the VM | `string` | `"pve"` | no |

## Outputs

| Name | Description |
|------|-------------|
| groups | The Ansible groups assigned to the VM |
| hostname | The hostname of the VM |
| ip | The IP address of the VM |
| username | The username of the VM |
| vmid | The ID of the VM in Proxmox |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->