
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.108"
    }
  }
  required_version = ">= 0.14.9"
}

provider "azurerm" {
features {}
}

module "name_generator" {
  source = "../modules/helpers/name_generator"
  cloud_code = var.cloud_code
  environment = var.environment
  project = var.project
}

module "resource_group" {
  source              = "../modules/azurerm/resource_group"
  name = module.name_generator.resource_group_name
  location            = var.location
  tags                = var.tags
}

module "virtual_subnet_network" {
  depends_on = [ module.resource_group ]
  source               = "../modules/azurerm/networking/vnet-subnet"
  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.location
  vnet_name            = module.name_generator.virtual_network_name
  vnet_address_space   = var.vnet_address_space
  subnet_name          = module.name_generator.subnet_name
  subnet_address_prefixes = var.subnet_address_prefixes
  tags                 = var.tags
}

module "key_vault" {
  depends_on = [ module.resource_group ]
  source              = "../modules/azurerm/keyvault"
  name      = module.name_generator.key_vault_name
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.location
  tags                = var.tags
  purge_protection_enabled = false
  sku_name                 = local.keyvault_sku
}

module "container_registry" {
  depends_on = [ module.resource_group ]
  source              = "../modules/azurerm/container_registry"
  name                = module.name_generator.container_registry_name
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.location
  sku                 = local.container_registry_sku
  tags                = var.tags
}

module "aks" {
  depends_on = [ module.resource_group, module.virtual_subnet_network ]
  source              = "../modules/azurerm/kubernetes/aks"
  name                = module.name_generator.aks_name
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.location
  dns_prefix          = module.name_generator.aks_dns_prefix
  node_count          = local.aks_node_count
  node_vm_size        = local.aks_node_vm_size
  subnet_id           = module.virtual_subnet_network.subnet_id
  tags                = var.tags
}

