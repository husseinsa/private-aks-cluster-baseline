# AKS Baseline


## Resources Convention Naming

This regional virtual network hub (shared) holds the following subnets:

- Resource Group
- AKS: aks{bu}
- ACR: acr{bu}
- Private Endpoint: pe-<resource-name>
- Public IP: pip-{resource-type}-{region}-{number}
- Subnet: snet-{resource-idetifier}
- VNET for Spoke: vnet-spoke-{bu-name}-{number}
- VNET for Hub: vnet-{region}-hub
- User Defined Routes: udr-route-to-{vnet}-{resource}