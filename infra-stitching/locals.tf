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
  aks_node_count = (
    var.environment == "dev" ? 1 : (
      var.environment == "prod" ? 3 : null
    )
  )
  aks_node_vm_size = (
    var.environment == "dev" ? "Standard_B2s" : (
      var.environment == "prod" ? "Standard_D4s_v3" : null
    )
  )
}