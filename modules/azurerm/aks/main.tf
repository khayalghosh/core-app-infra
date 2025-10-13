# terraform {
#   required_version = ">=1.0"

#   required_providers {
#     azapi = {
#       source  = "azure/azapi"
#       version = "~>1.5"
#     }
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "~>3.0"
#     }
#     random = {`
#       source  = "hashicorp/random"
#       version = "~>3.0"
#     }
#     time = {
#       source  = "hashicorp/time"
#       version = "0.9.1"
#     }
#   }
# }

# provider "azurerm" {
#   features {}

  #subscription_id   = "<azure_subscription_id>"
  #tenant_id         = "<azure_subscription_tenant_id>"
  #client_id         = "<service_principal_appid>"
  #client_secret     = "<service_principal_password>"
# }

resource "random_pet" "ssh_key_name" {
  prefix    = "ssh"
  separator = ""
}

resource "azapi_resource_action" "ssh_public_key_gen" {
  type        = "Microsoft.Compute/sshPublicKeys@2022-11-01"
  resource_id = azapi_resource.ssh_public_key.id
  action      = "generateKeyPair"
  method      = "POST"

  response_export_values = ["publicKey", "privateKey"]
}

resource "azapi_resource" "ssh_public_key" {
  type      = "Microsoft.Compute/sshPublicKeys@2022-11-01"
  name      = random_pet.ssh_key_name.id
  location  = azurerm_resource_group.rg.location
  parent_id = azurerm_resource_group.rg.id
}

output "key_data" {
  value = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
}


resource "random_pet" "azurerm_kubernetes_cluster_name" {
  prefix = "cluster"
}

resource "random_pet" "azurerm_kubernetes_cluster_dns_prefix" {
  prefix = "dns"
}

resource "azurerm_kubernetes_cluster" "k8s" {
  location            = var.resource_group_location
  name                = var.name
  resource_group_name = var.resource_group_name
  dns_prefix          = random_pet.azurerm_kubernetes_cluster_dns_prefix.id


  role_based_access_control_enabled = true

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_B2s"
    node_count = var.node_count
    vnet_subnet_id = var.subnet_id
    enable_host_encryption = false
  }
  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
    network_policy    = "azure"
    dns_service_ip    = "10.2.0.10"
    service_cidr      = "10.2.0.0/24"
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }
  storage_profile {
    blob_driver_enabled = false
    disk_driver_enabled = true
    file_driver_enabled = false
    snapshot_controller_enabled = true
  }
}