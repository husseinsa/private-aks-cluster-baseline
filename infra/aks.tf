
### AKS private DNS zone
resource "azurerm_private_dns_zone" "aks" {
  name                = "privatelink.eastus.azmk8s.io"
  resource_group_name = azurerm_resource_group.spoke1.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "hub_aks" {
  name                  = "to-${azurerm_virtual_network.hub.name}"
  resource_group_name   = azurerm_resource_group.spoke1.name
  private_dns_zone_name = azurerm_private_dns_zone.aks.name
  virtual_network_id    = azurerm_virtual_network.hub.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "spoke1_aks" {
  name                  = "to-${azurerm_virtual_network.spoke1.name}"
  resource_group_name   = azurerm_resource_group.spoke1.name
  private_dns_zone_name = azurerm_private_dns_zone.aks.name
  virtual_network_id    = azurerm_virtual_network.spoke1.id
}

### cluster identity
resource "azurerm_user_assigned_identity" "controlplane_identity" {
  name                = "mi-${var.aks_cluster_name}-controlplane"
  resource_group_name = azurerm_resource_group.spoke1.name
  location            = var.location
}

### Identity role assignment for cluster identity
resource "azurerm_role_assignment" "dns_contributor" {
  scope                = azurerm_private_dns_zone.aks.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.controlplane_identity.principal_id
}

resource "azurerm_role_assignment" "network_contributor" {
  scope                = azurerm_virtual_network.spoke1.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.controlplane_identity.principal_id
}


### AKS cluster creation
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.aks_cluster_name}-001"
  location            = var.location
  resource_group_name = azurerm_resource_group.spoke1.name
  kubernetes_version  = "1.28.0"
  private_cluster_enabled    = true
  dns_prefix_private_cluster = var.aks_cluster_name
  private_dns_zone_id        = azurerm_private_dns_zone.aks.id
  sku_tier = "Free"


  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.controlplane_identity.id, ]
  }

  default_node_pool {
    name           = "default"
    //os_disk_type   = "Ephemeral"  //Standard_D2_v2 doenst support ephemeral
    os_disk_size_gb   = 80
    vm_size        = "Standard_D2_v2"
    
    vnet_subnet_id = azurerm_subnet.spoke1_cluster_nodes_subnet.id
    enable_auto_scaling = true
    min_count = 1
    max_count = 3
  }
  

  network_profile {
    network_plugin     = "azure"
    network_policy = "azure"
    outbound_type = "userDefinedRouting"
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  //enable Azure AD Workload Identity
  workload_identity_enabled = true
  oidc_issuer_enabled = true 

 depends_on = [
    azurerm_role_assignment.network_contributor,
    azurerm_role_assignment.dns_contributor
  ]

} 

