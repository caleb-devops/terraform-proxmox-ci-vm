# Build Proxmox K3S cluster with Terraform and Ansible

<https://github.com/nbering/terraform-inventory/>

<https://github.com/k3s-io/k3s-ansible>

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

## Modules

| Name | Source | Version |
|------|--------|---------|
| k3s_agent | ../.. |  |
| k3s_server | ../.. |  |

## Resources

| Name |
|------|
| [ansible_group](https://registry.terraform.io/providers/nbering/ansible/latest/docs/resources/group) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| pm\_api\_url | The Proxmox API URL | `string` | n/a | yes |
| pm\_password | The Proxmox password | `string` | n/a | yes |
| pm\_user | The Proxmox username | `string` | n/a | yes |

## Outputs

No output.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->