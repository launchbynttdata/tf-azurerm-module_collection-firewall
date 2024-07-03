# tf-azurerm-module_collection-firewall

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: CC BY-NC-ND 4.0](https://img.shields.io/badge/License-CC_BY--NC--ND_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-nd/4.0/)

## Overview

Deploys an Azure Firewall resource with a Firewall Policy and an arbitrary number of Rule Collection Groups.

## Pre-Commit hooks

[.pre-commit-config.yaml](.pre-commit-config.yaml) file defines certain `pre-commit` hooks that are relevant to terraform, golang and common linting tasks. There are no custom hooks added.

`commitlint` hook enforces commit message in certain format. The commit contains the following structural elements, to communicate intent to the consumers of your commit messages:

- **fix**: a commit of the type `fix` patches a bug in your codebase (this correlates with PATCH in Semantic Versioning).
- **feat**: a commit of the type `feat` introduces a new feature to the codebase (this correlates with MINOR in Semantic Versioning).
- **BREAKING CHANGE**: a commit that has a footer `BREAKING CHANGE:`, or appends a `!` after the type/scope, introduces a breaking API change (correlating with MAJOR in Semantic Versioning). A BREAKING CHANGE can be part of commits of any type.
footers other than BREAKING CHANGE: <description> may be provided and follow a convention similar to git trailer format.
- **build**: a commit of the type `build` adds changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
- **chore**: a commit of the type `chore` adds changes that don't modify src or test files
- **ci**: a commit of the type `ci` adds changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)
- **docs**: a commit of the type `docs` adds documentation only changes
- **perf**: a commit of the type `perf` adds code change that improves performance
- **refactor**: a commit of the type `refactor` adds code change that neither fixes a bug nor adds a feature
- **revert**: a commit of the type `revert` reverts a previous commit
- **style**: a commit of the type `style` adds code changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- **test**: a commit of the type `test` adds missing tests or correcting existing tests

Base configuration used for this project is [commitlint-config-conventional (based on the Angular convention)](https://github.com/conventional-changelog/commitlint/tree/master/@commitlint/config-conventional#type-enum)

If you are a developer using vscode, [this](https://marketplace.visualstudio.com/items?itemName=joshbolduc.commitlint) plugin may be helpful.

`detect-secrets-hook` prevents new secrets from being introduced into the baseline. TODO: INSERT DOC LINK ABOUT HOOKS

In order for `pre-commit` hooks to work properly

- You need to have the pre-commit package manager installed. [Here](https://pre-commit.com/#install) are the installation instructions.
- `pre-commit` would install all the hooks when commit message is added by default except for `commitlint` hook. `commitlint` hook would need to be installed manually using the command below

```
pre-commit install --hook-type commit-msg
```

## To test the resource group module locally

1. For development/enhancements to this module locally, you'll need to install all of its components. This is controlled by the `configure` target in the project's [`Makefile`](./Makefile). Before you can run `configure`, familiarize yourself with the variables in the `Makefile` and ensure they're pointing to the right places.

```
make configure
```

This adds in several files and directories that are ignored by `git`. They expose many new Make targets.

2. _THIS STEP APPLIES ONLY TO MICROSOFT AZURE. IF YOU ARE USING A DIFFERENT PLATFORM PLEASE SKIP THIS STEP._ The first target you care about is `env`. This is the common interface for setting up environment variables. The values of the environment variables will be used to authenticate with cloud provider from local development workstation.

`make configure` command will bring down `azure_env.sh` file on local workstation. Devloper would need to modify this file, replace the environment variable values with relevant values.

These environment variables are used by `terratest` integration suit.

Service principle used for authentication(value of ARM_CLIENT_ID) should have below privileges on resource group within the subscription.

```
"Microsoft.Resources/subscriptions/resourceGroups/write"
"Microsoft.Resources/subscriptions/resourceGroups/read"
"Microsoft.Resources/subscriptions/resourceGroups/delete"
```

Then run this make target to set the environment variables on developer workstation.

```
make env
```

3. The first target you care about is `check`.

**Pre-requisites**
Before running this target it is important to ensure that, developer has created files mentioned below on local workstation under root directory of git repository that contains code for primitives/segments. Note that these files are `azure` specific. If primitive/segment under development uses any other cloud provider than azure, this section may not be relevant.

- A file named `provider.tf` with contents below

```
provider "azurerm" {
  features {}
}
```

- A file named `terraform.tfvars` which contains key value pair of variables used.

Note that since these files are added in `gitignore` they would not be checked in into primitive/segment's git repo.

After creating these files, for running tests associated with the primitive/segment, run

```
make check
```

If `make check` target is successful, developer is good to commit the code to primitive/segment's git repo.

`make check` target

- runs `terraform commands` to `lint`,`validate` and `plan` terraform code.
- runs `conftests`. `conftests` make sure `policy` checks are successful.
- runs `terratest`. This is integration test suit.
- runs `opa` tests
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | <= 1.5.5 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.77 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_firewall"></a> [firewall](#module\_firewall) | terraform.registry.launch.nttdata.com/module_primitive/firewall/azurerm | ~> 2.0 |
| <a name="module_policy"></a> [policy](#module\_policy) | terraform.registry.launch.nttdata.com/module_primitive/firewall_policy/azurerm | ~> 1.0 |
| <a name="module_rules"></a> [rules](#module\_rules) | terraform.registry.launch.nttdata.com/module_primitive/firewall_policy_rule_collection_group/azurerm | ~> 1.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the existing resource group into which resources will be provisioned. | `string` | n/a | yes |
| <a name="input_firewall_name"></a> [firewall\_name](#input\_firewall\_name) | Name of the firewall resource to be created. | `string` | n/a | yes |
| <a name="input_firewall_sku_name"></a> [firewall\_sku\_name](#input\_firewall\_sku\_name) | SKU name of the Firewall. Possible values are `AZFW_Hub` and `AZFW_VNet`, defaults to `AZFW_VNet`. Changing this forces a new resource to be created. | `string` | `"AZFW_VNet"` | no |
| <a name="input_firewall_sku_tier"></a> [firewall\_sku\_tier](#input\_firewall\_sku\_tier) | SKU tier of the Firewall. Possible values are `Basic`, `Standard`, and `Premium`. | `string` | n/a | yes |
| <a name="input_firewall_ip_configuration"></a> [firewall\_ip\_configuration](#input\_firewall\_ip\_configuration) | An IP configuration block to configure public IPs and subnets associated with this firewall. The Subnet used for the Firewall must have the name `AzureFirewallSubnet` and the subnet mask must be at least a /26. Any Public IPs must have a Static allocation and Standard SKU. One and only one ip\_configuration object may contain a `subnet_id`. A public ip address is required unless a `management_ip_configuration` block is specified. | <pre>list(object({<br>    name                 = string<br>    subnet_id            = string<br>    public_ip_address_id = string<br>  }))</pre> | `null` | no |
| <a name="input_firewall_dns_servers"></a> [firewall\_dns\_servers](#input\_firewall\_dns\_servers) | A list of DNS servers that the Azure Firewall will direct DNS traffic to the for name resolution. | `list(string)` | `null` | no |
| <a name="input_firewall_private_ip_ranges"></a> [firewall\_private\_ip\_ranges](#input\_firewall\_private\_ip\_ranges) | An optional list of SNAT private CIDR IP ranges, or the special string `IANAPrivateRanges`, which indicates Azure Firewall does not SNAT when the destination IP address is a private range per IANA RFC 1918. | `list(string)` | `null` | no |
| <a name="input_firewall_management_ip_configuration"></a> [firewall\_management\_ip\_configuration](#input\_firewall\_management\_ip\_configuration) | An IP Configuration block to configure force-tunnelling of traffic to be performed by the firewall. The Management Subnet used for the Firewall must have the name `AzureFirewallManagementSubnet` and the subnet mask must be at least a /26. The Public IP must have a `Static` allocation and `Standard` SKU. Adding or removing this block or changing the `subnet_id` in an existing block forces a new resource to be created. Changing this forces a new resource to be created. | <pre>object({<br>    name                 = string<br>    subnet_id            = string<br>    public_ip_address_id = string<br>  })</pre> | `null` | no |
| <a name="input_firewall_threat_intel_mode"></a> [firewall\_threat\_intel\_mode](#input\_firewall\_threat\_intel\_mode) | The operation mode for threat intelligence-based filtering. Possible values are: `Off`, `Alert` and `Deny`. Defaults to `Alert`. | `string` | `"Alert"` | no |
| <a name="input_firewall_virtual_hub"></a> [firewall\_virtual\_hub](#input\_firewall\_virtual\_hub) | Configuration to use a firewall with a Microsoft-managed Virtual Hub. | <pre>object({<br>    virtual_hub_id  = string<br>    public_ip_count = optional(number, 1)<br>  })</pre> | `null` | no |
| <a name="input_firewall_zones"></a> [firewall\_zones](#input\_firewall\_zones) | Specifies a list of Availability Zones in which this Azure Firewall should be located. Changing this forces a new Azure Firewall to be created. | `list(string)` | `null` | no |
| <a name="input_policy_name"></a> [policy\_name](#input\_policy\_name) | Name of the firewall policy resource to be created. | `string` | n/a | yes |
| <a name="input_policy_base_policy_id"></a> [policy\_base\_policy\_id](#input\_policy\_base\_policy\_id) | ID of the base Firewall policy. | `string` | `null` | no |
| <a name="input_policy_dns"></a> [policy\_dns](#input\_policy\_dns) | A Policy DNS block | <pre>object({<br>    proxy_enabled = bool<br>    servers       = list(string)<br>  })</pre> | `null` | no |
| <a name="input_policy_identity"></a> [policy\_identity](#input\_policy\_identity) | A Policy Identity block | <pre>object({<br>    type         = string<br>    identity_ids = list(string)<br>  })</pre> | `null` | no |
| <a name="input_policy_insights"></a> [policy\_insights](#input\_policy\_insights) | (Optional) A insights block | <pre>object({<br>    enabled                            = bool<br>    default_log_analytics_workspace_id = string<br>    retention_in_days                  = number<br>    log_analytics_workspace = list(object({<br>      id                = string<br>      firewall_location = string<br>    }))<br>  })</pre> | `null` | no |
| <a name="input_policy_intrusion_detection"></a> [policy\_intrusion\_detection](#input\_policy\_intrusion\_detection) | Intrusion detection is feature provided by Azure Firewall Premium tier for network intrusion detection and prevention. To configure intrusion detection, aintrusion\_detection block with below arguments is required. More information for each of these attributes can found at https://learn.microsoft.com/en-us/azure/firewall/premium-features#idps and https://techcommunity.microsoft.com/t5/azure-network-security-blog/intrusion-detection-and-prevention-system-idps-based-on/ba-p/3921330 | <pre>object({<br>    mode = string<br>    signature_overrides = list(object({<br>      id    = number<br>      state = string<br>    }))<br>    traffic_bypass = object({<br>      name                  = string<br>      protocol              = string<br>      description           = optional(string)<br>      destination_addresses = optional(list(string))<br>      destination_ip_groups = optional(list(string))<br>      destination_ports     = optional(list(string))<br>      source_addresses      = optional(list(string))<br>      source_ip_groups      = optional(list(string))<br>    })<br>    private_ranges = list(string)<br>  })</pre> | `null` | no |
| <a name="input_policy_private_ip_ranges"></a> [policy\_private\_ip\_ranges](#input\_policy\_private\_ip\_ranges) | A list of private IP ranges to which traffic will not be SNAT. | `list(string)` | `null` | no |
| <a name="input_policy_auto_learn_private_ranges_enabled"></a> [policy\_auto\_learn\_private\_ranges\_enabled](#input\_policy\_auto\_learn\_private\_ranges\_enabled) | Enable or disable auto learning of private IP ranges. | `bool` | `true` | no |
| <a name="input_policy_sku"></a> [policy\_sku](#input\_policy\_sku) | The SKU Tier of the Firewall Policy. Possible values are `Basic`, `Standard`, and `Premium`. Changing this forces a new Firewall Policy to be created. | `string` | `null` | no |
| <a name="input_rule_collection_groups"></a> [rule\_collection\_groups](#input\_rule\_collection\_groups) | Map of rule collection group objects. The key of the map will become the resource's name. | <pre>map(object({<br>    priority = number<br>    application_rule_collection = optional(list(object({<br>      name     = string<br>      action   = string<br>      priority = number<br>      rule = list(object({<br>        name        = string<br>        description = optional(string)<br>        protocols = optional(list(object({<br>          type = string<br>          port = number<br>        })))<br>        http_headers = optional(list(object({<br>          name  = string<br>          value = string<br>        })))<br>        source_addresses      = optional(list(string))<br>        source_ip_groups      = optional(list(string))<br>        destination_addresses = optional(list(string))<br>        destination_urls      = optional(list(string))<br>        destination_fqdns     = optional(list(string))<br>        destination_fqdn_tags = optional(list(string))<br>        terminate_tls         = optional(bool)<br>        web_categories        = optional(list(string))<br>      }))<br>    })), [])<br>    network_rule_collection = optional(list(object({<br>      name     = string<br>      action   = string<br>      priority = number<br>      rule = list(object({<br>        name                  = string<br>        description           = optional(string)<br>        protocols             = list(string)<br>        destination_ports     = list(string)<br>        source_addresses      = optional(list(string))<br>        source_ip_groups      = optional(list(string))<br>        destination_addresses = optional(list(string))<br>        destination_fqdns     = optional(list(string))<br>      }))<br>    })), [])<br>    nat_rule_collection = optional(list(object({<br>      name     = string<br>      action   = string<br>      priority = number<br>      rule = list(object({<br>        name                = string<br>        description         = optional(string)<br>        protocols           = list(string)<br>        source_addresses    = optional(list(string))<br>        source_ip_groups    = optional(list(string))<br>        destination_address = optional(string)<br>        destination_ports   = optional(list(string))<br>        translated_address  = optional(string)<br>        translated_port     = number<br>        translated_fqdn     = optional(string)<br>      }))<br>    })), [])<br>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_firewall_policy_id"></a> [firewall\_policy\_id](#output\_firewall\_policy\_id) | n/a |
| <a name="output_dns_servers"></a> [dns\_servers](#output\_dns\_servers) | n/a |
| <a name="output_firewall_ip_configuration"></a> [firewall\_ip\_configuration](#output\_firewall\_ip\_configuration) | n/a |
| <a name="output_management_ip_configuration"></a> [management\_ip\_configuration](#output\_management\_ip\_configuration) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
