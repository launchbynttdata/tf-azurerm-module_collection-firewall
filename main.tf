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

module "firewall" {
  source  = "d2lqlh14iel5k2.cloudfront.net/module_primitive/firewall/azurerm"
  version = "~> 2.0"

  firewall_policy_id  = module.policy.id
  resource_group_name = var.resource_group_name
  location            = var.location

  name                        = var.firewall_name
  sku_name                    = var.firewall_sku_name
  sku_tier                    = var.firewall_sku_tier
  ip_configuration            = var.firewall_ip_configuration
  dns_servers                 = var.firewall_dns_servers
  private_ip_ranges           = var.firewall_private_ip_ranges
  management_ip_configuration = var.firewall_management_ip_configuration
  threat_intel_mode           = var.firewall_threat_intel_mode
  virtual_hub                 = var.firewall_virtual_hub
  zones                       = var.firewall_zones

  tags = local.tags
}

module "policy" {
  source  = "d2lqlh14iel5k2.cloudfront.net/module_primitive/firewall_policy/azurerm"
  version = "~> 1.0"

  resource_group_name = var.resource_group_name
  location            = var.location

  name                              = var.policy_name
  base_policy_id                    = var.policy_base_policy_id
  dns                               = var.policy_dns
  identity                          = var.policy_identity
  insights                          = var.policy_insights
  intrusion_detection               = var.policy_intrusion_detection
  private_ip_ranges                 = var.policy_private_ip_ranges
  auto_learn_private_ranges_enabled = var.policy_auto_learn_private_ranges_enabled

  tags = local.tags
}

module "rules" {
  source  = "d2lqlh14iel5k2.cloudfront.net/module_primitive/firewall_policy_rule_collection_group/azurerm"
  version = "~> 1.0"

  for_each = var.rule_collection_groups

  firewall_policy_id = module.policy.id

  name                        = each.key
  priority                    = each.value.priority
  application_rule_collection = each.value.application_rule_collection
  network_rule_collection     = each.value.network_rule_collection
  nat_rule_collection         = each.value.nat_rule_collection
}
