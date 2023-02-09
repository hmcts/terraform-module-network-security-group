resource "azurerm_network_interface_security_group_association" "network_interface_association" {
  for_each                  = { for nic in var.network_interface_ids : "${split("/", nic)[8]}" => nic }
  network_interface_id      = each.value
  network_security_group_id = azurerm_network_security_group.network_security_group.id
}