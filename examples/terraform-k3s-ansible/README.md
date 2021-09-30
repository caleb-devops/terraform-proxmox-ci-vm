# Build Proxmox K3S cluster with Terraform and Ansible

<https://github.com/nbering/terraform-inventory/>

<https://github.com/k3s-io/k3s-ansible>

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.0 |
| proxmox | ~> 2.6.5 |

## Providers

No provider.

## Modules

| Name | Source | Version |
|------|--------|---------|
| k3s_agent | ../.. |  |
| k3s_server | ../.. |  |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| pm\_api\_url | The Proxmox API URL | `string` | n/a | yes |
| pm\_password | The Proxmox password | `string` | n/a | yes |
| pm\_user | The Proxmox username | `string` | n/a | yes |

## Outputs

No output.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->