resource "azurerm_resource_group" "hub" {
    name = var.rg_hubs_network_name
    location = var.location
}

resource "azurerm_resource_group" "spoke" {
    name = var.rg_spokes_network_name
    location = var.location
}

resource "azurerm_resource_group" "aks_spoke" {
    name = "rg-${var.business_unit}"
    location = var.location
}