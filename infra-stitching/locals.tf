locals {
  keyvault_sku = (
    var.environment == "dev" ? "standard" : (
      var.environment == "prod" ? "premium" : null
    )
  )
  container_registry_sku = (
    var.environment == "dev" ? "Basic" : (
      var.environment == "prod" ? "Standard" : null
    )
  )
}