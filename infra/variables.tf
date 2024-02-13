variable "location" {
    default = "eastus"  
}

variable "business_unit_name" {
  default = "accounting-001"
}

variable "rg_hubs_network_name" {
  default = "rg-networking-hubs"
}

variable "rg_spokes_network_name" {
  default = "rg-networking-spokes"
}

variable "vnet_hub_name" {
  default = "vnet-eastus-hub"
}

variable "aks_cluster_name" {
    default = "akscluster"  
}

variable "jump_box_name" {
    default = "jumpbox"
}

