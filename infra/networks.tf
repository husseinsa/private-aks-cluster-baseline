
# Hub Virtual Network
resource "azurerm_virtual_network" "hub" {
  name                = var.vnet_hub_name
  address_space       = ["10.200.0.0/24"]
  location            = var.location
  resource_group_name = azurerm_resource_group.network_hub.name
}

# Spoke 1 Virtual Network
resource "azurerm_virtual_network" "spoke1" {
  name                = "vnet-spoke-${var.business_unit_name}"
  address_space       = ["10.240.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.network_spoke.name
}

# Hub Subnets
resource "azurerm_subnet" "hub_azure_firewall_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.network_hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.200.0.0/26"]
}

resource "azurerm_subnet" "hub_gateway_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.network_hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.200.0.64/27"]
}

resource "azurerm_subnet" "hub_azure_bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.network_hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.200.0.96/27"]
}


resource "azurerm_subnet" "hub_azure_firewall_management_subnet" {
  name                 = "AzureFirewallManagementSubnet"
  resource_group_name  = azurerm_resource_group.network_hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.200.0.128/26"]
}

resource "azurerm_subnet" "hub_azure_jumpbox_subnet" {
  name                 = "snet-jumpbox"
  resource_group_name  = azurerm_resource_group.network_hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.200.0.192/28"]
}

# Spoke 1 Subnets
resource "azurerm_subnet" "spoke1_cluster_nodes_subnet" {
  name                 = "snet-clusternodes"
  resource_group_name  = azurerm_resource_group.network_spoke.name
  virtual_network_name = azurerm_virtual_network.spoke1.name
  address_prefixes     = ["10.240.0.0/22"]
}

resource "azurerm_subnet" "spoke1_cluster_ingress_subnet" {
  name                 = "snet-clusteringressservices"
  resource_group_name  = azurerm_resource_group.network_spoke.name
  virtual_network_name = azurerm_virtual_network.spoke1.name
  address_prefixes     = ["10.240.4.0/28"]
}

resource "azurerm_subnet" "spoke1_private_endpoints_subnet" {
  name                 = "snet-privateendpoints"
  resource_group_name  = azurerm_resource_group.network_spoke.name
  virtual_network_name = azurerm_virtual_network.spoke1.name
  address_prefixes     = ["10.240.4.32/27"]
}

resource "azurerm_subnet" "spoke1_applicationgateway_subnet" {
  name                 = "snet-applicationgateway"
  resource_group_name  = azurerm_resource_group.network_spoke.name
  virtual_network_name = azurerm_virtual_network.spoke1.name
  address_prefixes     = ["10.240.5.0/24"]
}


#["10.240.4.16/28"] available

