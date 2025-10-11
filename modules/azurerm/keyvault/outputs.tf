#############################################################################
# OUTPUTS
#############################################################################

output "name" {
  value       = azurerm_key_vault.keyvault.name
  description = "key vault resource name"
}

output "id" {
  value       = azurerm_key_vault.keyvault.id
  description = "key vault resource id"
}

output "tags" {
  value       = azurerm_key_vault.keyvault.tags
  description = "key vault resource tags"
}

output "vault_uri" {
  value       = azurerm_key_vault.keyvault.vault_uri
  description = "key vault resource  vault url"
}