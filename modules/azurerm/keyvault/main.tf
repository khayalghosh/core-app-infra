
data "azurerm_client_config" "current" {}

resource "azurerm_monitor_diagnostic_setting" "monitor_diagnostic_setting" {
  name                       = "${var.name}-mds"
  target_resource_id         = azurerm_key_vault.keyvault.id
  storage_account_id         = var.storage_account_id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  partner_solution_id        = var.partner_solution_id

  enabled_log {
    category = var.enabled_log_category

    retention_policy {
      enabled = var.enabled_log_retention_policy
    }
  }

  metric {
    category = var.metric_category

    retention_policy {
      enabled = var.metric_retention_policy
    }
  }
}


resource "azurerm_key_vault" "keyvault" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days    = var.soft_delete_retention_days
  purge_protection_enabled      = var.purge_protection_enabled
  sku_name                      = var.sku_name
  enable_rbac_authorization     = var.enable_rbac_authorization
  public_network_access_enabled = var.public_network_access_enabled
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = var.key_permissions

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }

  network_acls {
    default_action             = "Allow"
    bypass                     = "AzureServices"
    virtual_network_subnet_ids = var.virtual_network_subnet_ids
  }
  tags = merge(var.tags, { "created_by" = "dep_terraform", "type" = "keyvault", "DatadogLogs" = "true", "DatadogMetrics" = "true" })
}