#####################################################################
# Create NSG ########################################################
#####################################################################

resource "azurerm_network_security_group" "network_security_group" {
  name                = var.network_security_group_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

#####################################################################
# Add Blocking Rules. ###############################################
#####################################################################

resource "azurerm_network_security_rule" "DenyAzureLoadBalancerInbound" {
  access                      = "Deny"
  description                 = "Deny Traffic from Azure Load Balancer"
  destination_address_prefix  = "*"
  destination_port_range      = "*"
  direction                   = "Inbound"
  name                        = "DenyAzureLoadBalancerInbound"
  network_security_group_name = azurerm_network_security_group.network_security_group.name
  priority                    = 4096
  protocol                    = "*"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = "AzureLoadBalancer"
  source_port_range           = "*"
}

resource "azurerm_network_security_rule" "DenyVirtualNetworkInbound" {
  access                      = "Deny"
  description                 = "Deny Traffic from Virtual Network"
  destination_address_prefix  = "*"
  destination_port_range      = "*"
  direction                   = "Inbound"
  name                        = "DenyVirtualNetworkInbound"
  network_security_group_name = azurerm_network_security_group.network_security_group.name
  priority                    = 4095
  protocol                    = "*"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = "VirtualNetwork"
  source_port_range           = "*"
}

#####################################################################
# Add Custom Rules. #################################################
#####################################################################

resource "azurerm_network_security_rule" "custom_rules" {
  for_each                     = { for rule in var.custom_rules : rule.name => rule }
  access                       = try(each.value.access, "Allow")
  description                  = try(each.value.description, null)
  destination_address_prefix   = try(each.value.destination_address_prefix, null)
  destination_address_prefixes = try(each.value.destination_address_prefixes, null)
  destination_port_range       = try(each.value.destination_port_range, null)
  destination_port_ranges      = try(each.value.destination_port_ranges, null)
  direction                    = try(each.value.direction, "Inbound")
  name                         = try(each.value.name)
  network_security_group_name  = azurerm_network_security_group.network_security_group.name
  priority                     = try(each.value.priority)
  protocol                     = try(each.value.protocol, "*")
  resource_group_name          = var.resource_group_name
  source_address_prefix        = try(each.value.source_address_prefix, null)
  source_address_prefixes      = try(each.value.source_address_prefixes, null)
  source_port_range            = try(each.value.source_port_range, null)
  source_port_ranges           = try(each.value.source_port_ranges, null)
}

#####################################################################
# Attach TO Subnet & NICS. ##########################################
#####################################################################

resource "azurerm_subnet_network_security_group_association" "subnet_association" {
  for_each                  = { for subnet in var.subnet_ids : "${split("/", subnet)[10]}" => subnet }
  subnet_id                 = each.value
  network_security_group_id = azurerm_network_security_group.network_security_group.id
}

resource "azurerm_network_interface_security_group_association" "network_interface_association" {
  for_each                  = { for nic in var.network_interface_ids : "${split("/", nic)[8]}" => nic }
  network_interface_id      = each.value
  network_security_group_id = azurerm_network_security_group.network_security_group.id
}