#Route Tables for Spokes
resource "azurerm_route_table" "spoke1_to_hub_firewall" {
  name                = "udr-to-fw"
  resource_group_name = azurerm_resource_group.network_spoke.name
  location            = var.location

}

# User-defined Routes for Spokes to Hub Firewall
resource "azurerm_route" "spoke1_to_hub_firewall" {
  name                = "0-0-0-0-through-fw"
  resource_group_name = azurerm_resource_group.network_spoke.name
  route_table_name    = azurerm_route_table.spoke1_to_hub_firewall.name
  address_prefix      = "0.0.0.0/0"  
  next_hop_type       = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.hub_firewall.ip_configuration[0].private_ip_address # Replace with the actual IP address of your firewall
} 

# Associate Route Tables with Subnets
resource "azurerm_subnet_route_table_association" "spoke1_cluster_nodes_association" {
  subnet_id      = azurerm_subnet.spoke1_cluster_nodes_subnet.id
  route_table_id = azurerm_route_table.spoke1_to_hub_firewall.id
}

resource "azurerm_subnet_route_table_association" "spoke1_cluster_ingress_association" {
  subnet_id      = azurerm_subnet.spoke1_cluster_ingress_subnet.id
  route_table_id = azurerm_route_table.spoke1_to_hub_firewall.id
}