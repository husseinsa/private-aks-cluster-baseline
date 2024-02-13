locals {
    rg_bu_name =  "rg-${var.business_unit_name}"
}

resource "azurerm_resource_group" "network_hub" {
    name = var.rg_hubs_network_name
    location = var.location
}

resource "azurerm_resource_group" "network_spoke" {
    name = var.rg_spokes_network_name
    location = var.location
}

resource "azurerm_resource_group" "spoke1" {
    name = local.rg_bu_name
    location = var.location
}