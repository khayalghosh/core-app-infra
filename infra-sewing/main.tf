
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.108"
    }
  }
  required_version = ">= 0.14.9"
}


module "resource_group" {
  source              = "../modules/resource_group"
  resource_group_name = var.resource_group_name
  location            = var.location
  
}

module "virtual_network" {
  depends_on = [ module.resource_group ]
  source               = "../modules/azurerm/networking/vnet-subnet"
  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.location
  vnet_name            = var.vnet_name
  vnet_address_space   = var.vnet_address_space
  subnet_name          = var.subnet_name
  subnet_address_prefixes = var.subnet_address_prefixes
  tags                 = var.tags
}