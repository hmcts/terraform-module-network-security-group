data "azurerm_subnet" "subnet" {
  resource_group_name  = "hmcts-rg"
  virtual_network_name = "hmcts-vnet"
  name                 = "hmcts-snet"
}

data "azurerm_network_interface" "nic" {
  resource_group_name = "hmcts-rg"
  name                = "hmcts-nic"
}

module "nsg" {
  source = "../"

  network_security_group_name = "hmcts-nsg"
  resource_group_name         = "hmcts-rg"
  location                    = "uksouth"

  subnet_ids            = [data.azurerm_subnet.subnet.id]
  network_interface_ids = [data.azurerm_network_interface.nic.id]

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
