# terraform {
#   required_version = ">= 1.3.0"

#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "~> 4.0"
#     }
#   }
# }

provider "azurerm" {
  features {}
}

# Create Resource Group
resource "azurerm_resource_group" "acr_rg" {
  name     = var.resource_group_name
  location = var.location
}

# Create Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.acr_rg.name
  location            = azurerm_resource_group.acr_rg.location
  sku                 = var.sku
  admin_enabled       = var.admin_enabled

  tags = {
    environment = var.environment
    managed_by  = "terraform"
  }
}
