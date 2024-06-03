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
locals {
  default_tags = {
    provisioner = "terraform"
  }
  firewall_name        = module.resource_names["firewall"].minimal_random_suffix
  firewall_policy_name = module.resource_names["firewall_policy"].minimal_random_suffix
  resource_group_name  = module.resource_names["resource_group"].minimal_random_suffix
  virtual_network_name = module.resource_names["virtual_network"].minimal_random_suffix
  public_ip_name       = module.resource_names["public_ip"].minimal_random_suffix

  firewall_ip = module.firewall_collection.firewall_ip_configuration[0].private_ip_address

  firewall_ip_configuration = try([{
    name                 = "Default"
    subnet_id            = module.network.subnet_name_id_map["AzureFirewallSubnet"]
    public_ip_address_id = module.firewall_public_ip.id
  }], null)

  tags = merge(local.default_tags, var.tags)
}
