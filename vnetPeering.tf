
########################################
# Create vnet peering
########################################

resource "azurerm_virtual_network_peering" "vnet_peering-1" {
  name                      = "vnetPeer1to2"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet_application.name
  remote_virtual_network_id = azurerm_virtual_network.vnet_bastion.id
}

resource "azurerm_virtual_network_peering" "vnet_peering-2" {
  name                      = "vnetPeer2to1"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet_bastion.name
  remote_virtual_network_id = azurerm_virtual_network.vnet_application.id
}