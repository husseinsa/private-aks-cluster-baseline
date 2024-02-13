resource "azurerm_public_ip" "firewall_egress_ip" {
    name                        = "pip-fw-egress-eastus-01"
    location                    = var.location
    resource_group_name         = azurerm_resource_group.network_hub.name
    allocation_method           = "Static"
    sku                         = "Standard"
}

//required for Azure firewall operations and used exclusively by the Azure Platform required for Basic Sku
resource "azurerm_public_ip" "firewall_management_ip" {
    name                        = "pip-fw-management-eastus-01"
    location                    = var.location
    resource_group_name         = azurerm_resource_group.network_hub.name
    allocation_method           = "Static"
    sku                         = "Standard"
}

resource "azurerm_firewall" "hub_firewall" {
    name = "fw-${var.location}"
    location = var.location
    resource_group_name         = azurerm_resource_group.network_hub.name
    sku_name = "AZFW_VNet"
    sku_tier = "Basic"

    ip_configuration {
      name = "configuration"
      subnet_id = azurerm_subnet.hub_azure_firewall_subnet.id
      public_ip_address_id = azurerm_public_ip.firewall_egress_ip.id
    }

    management_ip_configuration {
        name = "management"
        subnet_id = azurerm_subnet.hub_azure_firewall_management_subnet.id //requires its own subnet "AzureFirewallManagementSubnet"
        public_ip_address_id = azurerm_public_ip.firewall_management_ip.id
    }
}

//firewall rules to allow AKS Egress traffic
resource "azurerm_firewall_network_rule_collection" "private_aks" {
    name                = "aks_network_rules"
    azure_firewall_name = azurerm_firewall.hub_firewall.name
    resource_group_name = azurerm_resource_group.network_hub.name
    priority            = 100
    action              = "Allow"
    rule { 
        name = "ntp"
        source_addresses  = [ 
            "*" 
        ]
        destination_addresses = [
            "*"
        ]
        destination_ports = [ 
            "123" 
        ]
        protocols = [ 
            "UDP" 
        ]
    }
    rule {
        name = "AzureMonitor"
        source_addresses = [ 
            "*" 
        ]
        destination_addresses = [ 
            "AzureMonitor" 
        ]
        destination_ports = [ 
            "443" 
        ]
        protocols = [ 
            "TCP" 
        ]
    }
    rule {
        name = "apiservertcp"
        source_addresses = [ 
            "*" 
        ]
        destination_addresses = [ 
            "AzureCloud" 
        ]
        destination_ports = [ 
            "443" , "9000", "22" 
        ]
        protocols = [ 
            "TCP" 
        ]
    }
     rule {
        name = "apiserverudp"
        source_addresses = [ 
            "*" 
        ]
        destination_addresses = [ 
            "AzureCloud" 
        ]
        destination_ports = [ 
            "1194"  
        ]
        protocols = [ 
            "UDP" 
        ]
    }
}

resource "azurerm_firewall_application_rule_collection" "aks_application_rule" {
    name = "aks_application_rules"
    resource_group_name = azurerm_resource_group.network_hub.name
    azure_firewall_name = azurerm_firewall.hub_firewall.name
    priority = 100
    action = "Allow"

    rule {
        name ="ubuntu"
        source_addresses = azurerm_subnet.spoke1_cluster_nodes_subnet.address_prefixes
        target_fqdns = [  
          "security.ubuntu.com",
          "azure.archive.ubuntu.com",
          "changelogs.ubuntu.com"
        ]
        protocol {
            port = "80"
            type = "Http"
        }
    }

    rule {
        name ="azure"
        source_addresses = azurerm_subnet.spoke1_cluster_nodes_subnet.address_prefixes
        target_fqdns = [  
            "mcr.microsoft.com",
            "*.data.mcr.microsoft.com",
            "management.azure.com",
            "login.microsoftonline.com",
            "packages.microsoft.com",
            "acs-mirror.azureedge.net"
        ]
        protocol {
            port = "443"
            type = "Https"
        }
    }

     rule {
        name ="monitoring"
        source_addresses = azurerm_subnet.spoke1_cluster_nodes_subnet.address_prefixes
        target_fqdns = [  
            "dc.services.visualstudio.com",
            "*.monitoring.azure.com",
            "*.oms.opinsights.azure.com",
            "*.ods.opinsights.azure.com"

        ]
        protocol {
            port = "443"
            type = "Https"
        }
    }

    
    rule {
        name ="docker"
        source_addresses = azurerm_subnet.spoke1_cluster_nodes_subnet.address_prefixes
        target_fqdns = [  
            "*.docker.io", "*.docker.com",
        ]
        protocol {
            port = "443"
            type = "Https"
        }
    }
}

