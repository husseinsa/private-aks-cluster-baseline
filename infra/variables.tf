variable "location" {
    default = "eastus"  
}

variable "business_unit_name" {
  default = "accounting_001"
}

variable "rg_hubs_network_name" {
  default = "rg-networking-hubs"
}

variable "rg_spokes_network_name" {
  default = "rg-networking-spokes"
}

variable "rg_bu_name" { 
    default = "rg-${var.business_unit_name}" 
}

variable "vnet_hub_name" {
  default = "vnet-${var.location}-hub"
}

variable "vnet_spoke1_name" {
  default = "vnet-spoke-${var.business_unit_name}-001"
}


variable "aks_cluster_name" {
    default = "akscluster"  
}

variable "jump_box_name" {
    default = "jumpbox"
}

