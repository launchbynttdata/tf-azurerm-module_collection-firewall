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

variable "resource_names_map" {
  description = "A map of key to resource_name that will be used by tf-launch-module_library-resource_name to generate resource names"
  type = map(object({
    name       = string
    max_length = optional(number, 60)
  }))

  default = {
    resource_group = {
      name = "rg"
    }
    firewall = {
      name = "fw"
    }
    virtual_network = {
      name = "vnet"
    }
    public_ip = {
      name = "ip"
    }
    firewall_policy = {
      name = "plcy"
    }
    rule_collection_group = {
      name = "rules"
    }
  }
}

variable "instance_env" {
  type        = number
  description = "Number that represents the instance of the environment."
  default     = 0

  validation {
    condition     = var.instance_env >= 0 && var.instance_env <= 999
    error_message = "Instance number should be between 0 to 999."
  }
}

variable "instance_resource" {
  type        = number
  description = "Number that represents the instance of the resource."
  default     = 0

  validation {
    condition     = var.instance_resource >= 0 && var.instance_resource <= 100
    error_message = "Instance number should be between 0 to 100."
  }
}

variable "logical_product_family" {
  type        = string
  description = <<EOF
    (Required) Name of the product family for which the resource is created.
    Example: org_name, department_name.
  EOF
  nullable    = false

  validation {
    condition     = can(regex("^[_\\-A-Za-z0-9]+$", var.logical_product_family))
    error_message = "The variable must contain letters, numbers, -, _, and .."
  }

  default = "launch"
}

variable "logical_product_service" {
  type        = string
  description = <<EOF
    (Required) Name of the product service for which the resource is created.
    For example, backend, frontend, middleware etc.
  EOF
  nullable    = false

  validation {
    condition     = can(regex("^[_\\-A-Za-z0-9]+$", var.logical_product_service))
    error_message = "The variable must contain letters, numbers, -, _, and .."
  }

  default = "firewall"
}

variable "class_env" {
  type        = string
  description = "(Required) Environment where resource is going to be deployed. For example. dev, qa, uat"
  nullable    = false
  default     = "demo"

  validation {
    condition     = length(regexall("\\b \\b", var.class_env)) == 0
    error_message = "Spaces between the words are not allowed."
  }
}

variable "location" {
  description = "Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
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

variable "address_space" {
  description = "CIDR prefix of the address space for the created Virtual Network."
  type        = string
  default     = "172.16.0.0/16"
}

variable "subnets" {
  description = "Map of subnet name to CIDR prefix to be created. Azure Firewall requires a subnet named `AzureFirewallSubnet` of at least /26 to operate."
  type = map(object({
    prefix = string
    delegation = optional(object({
      name    = string
      actions = list(string)
    }), null)
    service_endpoints                             = optional(list(string), []),
    private_endpoint_network_policies_enabled     = optional(bool, false)
    private_link_service_network_policies_enabled = optional(bool, false)
    network_security_group_id                     = optional(string, null)
    route_table_id                                = optional(string, null)
    extra_tags                                    = optional(map(string), {})
  }))
  default = {
    AzureFirewallSubnet = {
      prefix = "172.16.0.0/26"
    }
  }
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
