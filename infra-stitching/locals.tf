locals {
  keyvault_sku = (
    var.environment == "dev" ? "standard" : (
      var.environment == "prod" ? "premium" : null
    )
  )
}