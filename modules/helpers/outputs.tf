output "kubernetes_cluster_name" {
  description = "output of kubernetes_cluster_name"
  value       = module.naming.kubernetes_cluster.name
}

output "application_gateway_name" {
  description = "output of application_gateway_name"
  value       = module.naming.application_gateway.name
}

output "container_registry_name" {
  description = "output of container_registry_name"
  value       = module.naming.container_registry.name
}

output "resource_group_name" {
  description = "output of resource_group_name"
  value       = module.naming.resource_group.name
}
output "virtual_network_name" {
  description = "output of virtual_network_name"
  value       = module.naming.virtual_network.name
}

output "subnet_name" {
  description = "output of subnet_name"
  value       = module.naming.subnet.name
}

output "keyvault_name" {
  description = "output of keyvault_name"
  value       = module.naming.keyvault.name
}