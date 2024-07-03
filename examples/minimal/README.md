# minimal

A minimal example, demonstrating a firewall with a standalone virtual network. This example is intended to be peered manually to existing virtual networks. This example includes a single public IP which is attached to the firewall normally (i.e. does not use a management IP configuration).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | <= 1.5.5 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.77.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_firewall_collection"></a> [firewall\_collection](#module\_firewall\_collection) | ../.. | n/a |
| <a name="module_firewall_public_ip"></a> [firewall\_public\_ip](#module\_firewall\_public\_ip) | terraform.registry.launch.nttdata.com/module_primitive/public_ip/azurerm | ~> 1.0 |
| <a name="module_network"></a> [network](#module\_network) | terraform.registry.launch.nttdata.com/module_primitive/virtual_network/azurerm | ~> 3.0 |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | terraform.registry.launch.nttdata.com/module_primitive/resource_group/azurerm | ~> 1.0 |
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | terraform.registry.launch.nttdata.com/module_library/resource_name/launch | ~> 1.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | A map of key to resource\_name that will be used by tf-launch-module\_library-resource\_name to generate resource names | <pre>map(object({<br>    name       = string<br>    max_length = optional(number, 60)<br>  }))</pre> | <pre>{<br>  "firewall": {<br>    "name": "fw"<br>  },<br>  "firewall_policy": {<br>    "name": "plcy"<br>  },<br>  "public_ip": {<br>    "name": "ip"<br>  },<br>  "resource_group": {<br>    "name": "rg"<br>  },<br>  "rule_collection_group": {<br>    "name": "rules"<br>  },<br>  "virtual_network": {<br>    "name": "vnet"<br>  }<br>}</pre> | no |
| <a name="input_instance_env"></a> [instance\_env](#input\_instance\_env) | Number that represents the instance of the environment. | `number` | `0` | no |
| <a name="input_instance_resource"></a> [instance\_resource](#input\_instance\_resource) | Number that represents the instance of the resource. | `number` | `0` | no |
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | (Required) Name of the product family for which the resource is created.<br>    Example: org\_name, department\_name. | `string` | `"launch"` | no |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | (Required) Name of the product service for which the resource is created.<br>    For example, backend, frontend, middleware etc. | `string` | `"firewall"` | no |
| <a name="input_class_env"></a> [class\_env](#input\_class\_env) | (Required) Environment where resource is going to be deployed. For example. dev, qa, uat | `string` | `"demo"` | no |
| <a name="input_location"></a> [location](#input\_location) | Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_rule_collection_groups"></a> [rule\_collection\_groups](#input\_rule\_collection\_groups) | Map of rule collection group objects. The key of the map will become the resource's name. | <pre>map(object({<br>    priority = number<br>    application_rule_collection = optional(list(object({<br>      name     = string<br>      action   = string<br>      priority = number<br>      rule = list(object({<br>        name        = string<br>        description = optional(string)<br>        protocols = optional(list(object({<br>          type = string<br>          port = number<br>        })))<br>        http_headers = optional(list(object({<br>          name  = string<br>          value = string<br>        })))<br>        source_addresses      = optional(list(string))<br>        source_ip_groups      = optional(list(string))<br>        destination_addresses = optional(list(string))<br>        destination_urls      = optional(list(string))<br>        destination_fqdns     = optional(list(string))<br>        destination_fqdn_tags = optional(list(string))<br>        terminate_tls         = optional(bool)<br>        web_categories        = optional(list(string))<br>      }))<br>    })), [])<br>    network_rule_collection = optional(list(object({<br>      name     = string<br>      action   = string<br>      priority = number<br>      rule = list(object({<br>        name                  = string<br>        description           = optional(string)<br>        protocols             = list(string)<br>        destination_ports     = list(string)<br>        source_addresses      = optional(list(string))<br>        source_ip_groups      = optional(list(string))<br>        destination_addresses = optional(list(string))<br>        destination_fqdns     = optional(list(string))<br>      }))<br>    })), [])<br>    nat_rule_collection = optional(list(object({<br>      name     = string<br>      action   = string<br>      priority = number<br>      rule = list(object({<br>        name                = string<br>        description         = optional(string)<br>        protocols           = list(string)<br>        source_addresses    = optional(list(string))<br>        source_ip_groups    = optional(list(string))<br>        destination_address = optional(string)<br>        destination_ports   = optional(list(string))<br>        translated_address  = optional(string)<br>        translated_port     = number<br>        translated_fqdn     = optional(string)<br>      }))<br>    })), [])<br>  }))</pre> | `{}` | no |
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | CIDR prefix of the address space for the created Virtual Network. | `string` | `"172.16.0.0/16"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Map of subnet name to CIDR prefix to be created. Azure Firewall requires a subnet named `AzureFirewallSubnet` of at least /26 to operate. | <pre>map(object({<br>    prefix = string<br>    delegation = optional(object({<br>      name    = string<br>      actions = list(string)<br>    }), null)<br>    service_endpoints                             = optional(list(string), []),<br>    private_endpoint_network_policies_enabled     = optional(bool, false)<br>    private_link_service_network_policies_enabled = optional(bool, false)<br>    network_security_group_id                     = optional(string, null)<br>    route_table_id                                = optional(string, null)<br>    extra_tags                                    = optional(map(string), {})<br>  }))</pre> | <pre>{<br>  "AzureFirewallSubnet": {<br>    "prefix": "172.16.0.0/26"<br>  }<br>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_firewall_id"></a> [firewall\_id](#output\_firewall\_id) | n/a |
| <a name="output_firewall_ip_configuration"></a> [firewall\_ip\_configuration](#output\_firewall\_ip\_configuration) | n/a |
| <a name="output_firewall_name"></a> [firewall\_name](#output\_firewall\_name) | n/a |
| <a name="output_firewall_private_ip"></a> [firewall\_private\_ip](#output\_firewall\_private\_ip) | n/a |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
