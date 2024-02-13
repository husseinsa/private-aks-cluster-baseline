# Azure Kubernetes Service cluster baseline

## Resource groups
 - rg-networking-hubs
 - rg-networking-spokes
 - rg-accounting-001

## Networking
 - Hub Virtual Network with required subnets for firewall, jumpbox, gateways (optional)
 - Spoke Virtual Network with required subnets for: AKS clusters, AKS ingress services, Application Gateway & Private endpoints for services used by the spoke
 - Azure Firewall (Basic SKU) in hub network
 - UDR for spoke cluster subnets to egress traffic through hub firewall 
 - NSGS to be implemented at a later step

## AKS

