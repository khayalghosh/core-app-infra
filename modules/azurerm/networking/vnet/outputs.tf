#############################################################################
# OUTPUTS
#############################################################################

output "id" {
  value       = azurerm_virtual_network.vnet.id
  description = "virtual network resource id"
}

output "name" {
  value       = azurerm_virtual_network.vnet.name
  description = "virtual network name"
}
output "resource_group_name" {
  value       = azurerm_virtual_network.vnet.resource_group_name
  description = "virtual network name"
}

output "tags" {
  value       = azurerm_virtual_network.vnet.tags
  description = "virtual network resource tags"
}

output "location" {
  value       = azurerm_virtual_network.vnet.location
  description = "virtual network resource location"
}

output "address_space" {
  value       = azurerm_virtual_network.vnet.address_space
  description = "virtual network address space"
}