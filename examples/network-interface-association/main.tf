data "azurerm_network_interface" "nic_01" {
  resource_group_name = "hmcts-rg"
  name                = "nic-01"
}

data "azurerm_network_interface" "nic_02" {
  resource_group_name = "hmcts-rg"
  name                = "nic-02"
}

module "nsg" {
  source = "git::https://github.com/hmcts/terraform-module-network-security-group.git?ref=v1.0.0"

  network_security_group_name = "hmcts-nsg"
  resource_group_name         = "hmcts-rg"
  location                    = "uksouth"

  network_interfaces = [
    {
      name = data.azurerm_network_interface.nic_01.name
      id   = data.azurerm_network_interface.nic_01.id
    },
    {
      name = data.azurerm_network_interface.nic_02.name
      id   = data.azurerm_network_interface.nic_02.id
    }
  ]

  custom_rules = [
    {
      access                       = "Allow"
      description                  = "Allow Application Gateway"
      destination_address_prefixes = ["10.10.1.0/24", "10.10.2.0/24"]
      destination_port_ranges      = ["80", "443"]
      direction                    = "Inbound"
      name                         = "AllowApplicationGateway"
      priority                     = 100
      protocol                     = "*"
      source_address_prefixes      = ["10.1.1.0/24", "10.1.2.0/24"]
      source_port_range            = "*"
    },
    {
      access                     = "Allow"
      description                = "Allow SSH"
      destination_address_prefix = "10.10.1.0/24"
      destination_port_range     = "22"
      direction                  = "Inbound"
      name                       = "AllowSSH"
      priority                   = 200
      protocol                   = "*"
      source_address_prefix      = "10.1.1.0/24"
      source_port_range          = "*"
    }
  ]
}