# Peering Hub and Spoke Virtual Networks
resource "azurerm_virtual_network_peering" "hub_to_spoke1" {
  name                         = "vnet-hub-to-vnet_spoke_01"
  resource_group_name          = azurerm_resource_group.network_hub.name
  virtual_network_name         = azurerm_virtual_network.hub.name 
  remote_virtual_network_id    = azurerm_virtual_network.spoke1.id
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                         = "vnet-spoke-01-to-vnet-hub"
  resource_group_name          = azurerm_resource_group.network_spoke.name
  virtual_network_name         = azurerm_virtual_network.spoke1.name
  remote_virtual_network_id    = azurerm_virtual_network.hub.id
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false

}