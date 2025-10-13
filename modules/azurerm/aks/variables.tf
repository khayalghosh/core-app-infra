variable "resource_group_name" {
  type        = string
  description = "Name of the existing resource group."
}

variable "subnet_id" {
  type        = string
  description = "ID of the existing subnet to attach the AKS cluster."
}
variable "resource_group_location" {
  type        = string
  default     = "eastus"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "node_count" {
  type        = number
  description = "The initial quantity of nodes for the node pool."
  default     = 3
}

variable "name" {
  type        = string
  description = "The name of the AKS cluster."
}