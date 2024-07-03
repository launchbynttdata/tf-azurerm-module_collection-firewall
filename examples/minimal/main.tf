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

module "firewall_collection" {
  source = "../.."

  location            = var.location
  resource_group_name = local.resource_group_name

  firewall_sku_tier = "Standard"
  policy_sku        = "Standard"
  firewall_name     = local.firewall_name
  policy_name       = local.firewall_policy_name

  firewall_ip_configuration = local.firewall_ip_configuration
  rule_collection_groups    = var.rule_collection_groups

  depends_on = [module.resource_group]
}

module "firewall_public_ip" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/public_ip/azurerm"
  version = "~> 1.0"

  name                = local.public_ip_name
  resource_group_name = local.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = local.tags

  depends_on = [module.resource_group]
}

module "network" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/virtual_network/azurerm"
  version = "~> 3.0"

  resource_group_name = local.resource_group_name

  vnet_name     = local.virtual_network_name
  vnet_location = var.location
  address_space = [var.address_space]
  subnets       = var.subnets

  tags = local.tags

  depends_on = [module.resource_group]
}

module "resource_group" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/resource_group/azurerm"
  version = "~> 1.0"

  name     = local.resource_group_name
  location = var.location

  tags = local.tags
}

module "resource_names" {
  source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version = "~> 1.0"

  for_each = var.resource_names_map

  region                  = join("", split("-", var.location))
  class_env               = var.class_env
  cloud_resource_type     = each.value.name
  instance_env            = var.instance_env
  instance_resource       = var.instance_resource
  maximum_length          = each.value.max_length
  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
}
