locals {
  key_vault_name = module.name_generator.keyvault_name
  keyvault_sku = (
    var.environment == "dev" ? "standard" : (
      var.environment == "prod" ? "premium" : null
    )
  )
}