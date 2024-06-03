location      = "eastus2"
address_space = "172.16.0.0/16"
subnets = {
  AzureFirewallSubnet = {
    prefix = "172.16.0.0/26"
  }
}

rule_collection_groups = {
  "example" = {
    priority = 100
    network_rule_collection = [
      {
        action   = "Allow"
        name     = "example_network_rule"
        priority = 100
        rule = [
          {
            description           = "SSH Inbound"
            destination_addresses = ["172.16.12.34/32"]
            destination_ports     = ["22"]
            name                  = "example_inbound_ssh_host_one"
            protocols             = ["TCP"]
            source_addresses      = ["10.0.0.0/16"]
          },
          {
            description           = "SSH Inbound"
            destination_addresses = ["172.16.56.78/32"]
            destination_ports     = ["22"]
            name                  = "example_inbound_ssh_host_two"
            protocols             = ["TCP"]
            source_addresses      = ["10.0.0.0/16"]
          }
        ]
      }
    ]
  }
}
