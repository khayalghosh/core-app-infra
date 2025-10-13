module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
  prefix  = [local.first_prefix]
  suffix  = [local.second_prefix]
}

locals {
  first_prefix = format("%s%s", var.cloud_code, var.environment)
  second_prefix = format("%s", var.project)
}