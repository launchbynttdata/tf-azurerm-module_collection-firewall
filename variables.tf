// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

variable "location" {
  description = "Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the existing resource group into which resources will be provisioned."
  type        = string
}

variable "firewall_name" {
  description = "Name of the firewall resource to be created."
  type        = string
}

variable "firewall_sku_name" {
  description = "SKU name of the Firewall. Possible values are `AZFW_Hub` and `AZFW_VNet`, defaults to `AZFW_VNet`. Changing this forces a new resource to be created."
  type        = string
  default     = "AZFW_VNet"

  validation {
    condition     = contains(["AZFW_Hub", "AZFW_VNet"], var.firewall_sku_name)
    error_message = "firewall_sku_name must contain either 'AZFW_Hub' or 'AZFW_VNet'."
  }
}

variable "firewall_sku_tier" {
  description = "SKU tier of the Firewall. Possible values are `Basic`, `Standard`, and `Premium`."
  type        = string

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.firewall_sku_tier)
    error_message = "firewall_sku_tier must contain either 'Basic', 'Standard', or 'Premium'."
  }
}

variable "firewall_ip_configuration" {
  description = "An IP configuration block to configure public IPs and subnets associated with this firewall. The Subnet used for the Firewall must have the name `AzureFirewallSubnet` and the subnet mask must be at least a /26. Any Public IPs must have a Static allocation and Standard SKU. One and only one ip_configuration object may contain a `subnet_id`. A public ip address is required unless a `management_ip_configuration` block is specified."
  type = list(object({
    name                 = string
    subnet_id            = string
    public_ip_address_id = string
  }))
  default = null
}

variable "firewall_dns_proxy_enabled" {
  description = "Whether DNS proxy is enabled on the Azure Firewall. It will forward DNS requests to the DNS servers when set to `true`. It will be set to `true` if `dns_servers` was provided with a non-empty list."
  type        = bool
  default     = false
}

variable "firewall_dns_servers" {
  description = "A list of DNS servers that the Azure Firewall will direct DNS traffic to the for name resolution."
  type        = list(string)
  default     = null
}

variable "firewall_private_ip_ranges" {
  description = "An optional list of SNAT private CIDR IP ranges, or the special string `IANAPrivateRanges`, which indicates Azure Firewall does not SNAT when the destination IP address is a private range per IANA RFC 1918."
  type        = list(string)
  default     = null
}

variable "firewall_management_ip_configuration" {
  description = "An IP Configuration block to configure force-tunnelling of traffic to be performed by the firewall. The Management Subnet used for the Firewall must have the name `AzureFirewallManagementSubnet` and the subnet mask must be at least a /26. The Public IP must have a `Static` allocation and `Standard` SKU. Adding or removing this block or changing the `subnet_id` in an existing block forces a new resource to be created. Changing this forces a new resource to be created."
  type = object({
    name                 = string
    subnet_id            = string
    public_ip_address_id = string
  })
  default = null
}

variable "firewall_threat_intel_mode" {
  description = "The operation mode for threat intelligence-based filtering. Possible values are: `Off`, `Alert` and `Deny`. Defaults to `Alert`."
  type        = string
  default     = "Alert"

  validation {
    condition     = contains(["Off", "Alert", "Deny"], var.firewall_threat_intel_mode)
    error_message = "firewall_threat_intel_mode must contain either 'Off', 'Alert', or 'Deny'."
  }
}

variable "firewall_virtual_hub" {
  description = "Configuration to use a firewall with a Microsoft-managed Virtual Hub."
  type = object({
    virtual_hub_id  = string
    public_ip_count = optional(number, 1)
  })
  default = null
}

variable "firewall_zones" {
  description = "Specifies a list of Availability Zones in which this Azure Firewall should be located. Changing this forces a new Azure Firewall to be created."
  type        = list(string)
  default     = null
}

variable "policy_name" {
  description = "Name of the firewall policy resource to be created."
  type        = string
}

variable "policy_base_policy_id" {
  description = "ID of the base Firewall policy."
  type        = string
  default     = null
}

variable "policy_dns" {
  description = "A Policy DNS block"
  type = object({
    proxy_enabled = bool
    servers       = list(string)
  })
  default = null
}

variable "policy_identity" {
  description = "A Policy Identity block"
  type = object({
    type         = string
    identity_ids = list(string)
  })
  default = null
}

variable "policy_insights" {
  description = "(Optional) A insights block"
  type = object({
    enabled                            = bool
    default_log_analytics_workspace_id = string
    retention_in_days                  = number
    log_analytics_workspace = list(object({
      id                = string
      firewall_location = string
    }))
  })
  default = null
}

variable "policy_intrusion_detection" {
  description = "Intrusion detection is feature provided by Azure Firewall Premium tier for network intrusion detection and prevention. To configure intrusion detection, aintrusion_detection block with below arguments is required. More information for each of these attributes can found at https://learn.microsoft.com/en-us/azure/firewall/premium-features#idps and https://techcommunity.microsoft.com/t5/azure-network-security-blog/intrusion-detection-and-prevention-system-idps-based-on/ba-p/3921330"
  type = object({
    mode = string
    signature_overrides = list(object({
      id    = number
      state = string
    }))
    traffic_bypass = object({
      name                  = string
      protocol              = string
      description           = optional(string)
      destination_addresses = optional(list(string))
      destination_ip_groups = optional(list(string))
      destination_ports     = optional(list(string))
      source_addresses      = optional(list(string))
      source_ip_groups      = optional(list(string))
    })
    private_ranges = list(string)
  })
  default = null
}

variable "policy_private_ip_ranges" {
  description = "A list of private IP ranges to which traffic will not be SNAT."
  type        = list(string)
  default     = null
}

variable "policy_auto_learn_private_ranges_enabled" {
  description = "Enable or disable auto learning of private IP ranges."
  type        = bool
  default     = true
}

variable "policy_sku" {
  description = "The SKU Tier of the Firewall Policy. Possible values are `Basic`, `Standard`, and `Premium`. Changing this forces a new Firewall Policy to be created."
  type        = string
  default     = null

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.policy_sku)
    error_message = "policy_sku must contain 'Basic', 'Standard', or 'Premium'"
  }
}

variable "rule_collection_groups" {
  description = "Map of rule collection group objects. The key of the map will become the resource's name."
  type = map(object({
    priority = number
    application_rule_collection = optional(list(object({
      name     = string
      action   = string
      priority = number
      rule = list(object({
        name        = string
        description = optional(string)
        protocols = optional(list(object({
          type = string
          port = number
        })))
        http_headers = optional(list(object({
          name  = string
          value = string
        })))
        source_addresses      = optional(list(string))
        source_ip_groups      = optional(list(string))
        destination_addresses = optional(list(string))
        destination_urls      = optional(list(string))
        destination_fqdns     = optional(list(string))
        destination_fqdn_tags = optional(list(string))
        terminate_tls         = optional(bool)
        web_categories        = optional(list(string))
      }))
    })), [])
    network_rule_collection = optional(list(object({
      name     = string
      action   = string
      priority = number
      rule = list(object({
        name                  = string
        description           = optional(string)
        protocols             = list(string)
        destination_ports     = list(string)
        source_addresses      = optional(list(string))
        source_ip_groups      = optional(list(string))
        destination_addresses = optional(list(string))
        destination_fqdns     = optional(list(string))
      }))
    })), [])
    nat_rule_collection = optional(list(object({
      name     = string
      action   = string
      priority = number
      rule = list(object({
        name                = string
        description         = optional(string)
        protocols           = list(string)
        source_addresses    = optional(list(string))
        source_ip_groups    = optional(list(string))
        destination_address = optional(string)
        destination_ports   = optional(list(string))
        translated_address  = optional(string)
        translated_port     = number
        translated_fqdn     = optional(string)
      }))
    })), [])
  }))
  default = {}
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
