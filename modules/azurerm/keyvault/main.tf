
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "keyvault" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days    = var.soft_delete_retention_days
  purge_protection_enabled      = var.purge_protection_enabled
  sku_name                      = var.sku_name
  enable_rbac_authorization     = true
  public_network_access_enabled = var.public_network_access_enabled
  tags = var.tags

  network_acls {
    default_action             = "Allow"
    bypass                     = "AzureServices"
    virtual_network_subnet_ids = var.virtual_network_subnet_ids
  }
}