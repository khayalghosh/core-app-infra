
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.108"
    }
  }
  required_version = ">= 0.14.9"
}


module "name_generator" {
  source = "../modules/helpers/name_generator"
  cloud_code = var.cloudcode
  environment = var.environment
  project = var.project
}

module "resource_group" {
  source              = "../modules/resource_group"
  resource_group_name = module.name_generator.resource_group_name
  location            = var.location
  
}

module "virtual_subnet_network" {
  depends_on = [ module.resource_group ]
  source               = "../modules/azurerm/networking/vnet-subnet"
  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.location
  vnet_name            = module.name_generator.vnet_name
  vnet_address_space   = var.vnet_address_space
  subnet_name          = module.name_generator.subnet_name
  subnet_address_prefixes = var.subnet_address_prefixes
  tags                 = var.tags
}

module "key_vault" {
  depends_on = [ module.resource_group ]
  source              = "../modules/azurerm/keyvault"
  name      = module.name_generator.keyvault_name
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.location
  tags                = var.tags
  purge_protection_enabled = false
  sku_name                 = "standard"
}