variable "name" {
  description = "The name of the Application Gateway."
  type        = string
}

variable "location" {
  description = "The Azure location."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "sku_name" {
  description = "The SKU name."
  type        = string
  default     = "Standard_v2"
}

variable "sku_tier" {
  description = "The SKU tier."
  type        = string
  default     = "Standard_v2"
}

variable "sku_capacity" {
  description = "The capacity of the SKU."
  type        = number
  default     = 2
}

variable "subnet_id" {
  description = "The subnet ID for the Application Gateway."
  type        = string
}

variable "private_ip_address" {
  description = "The private IP address to assign."
  type        = string
  default     = null
}

variable "backend_ip_addresses" {
  description = "List of backend IP addresses."
  type        = list(string)
  default     = []
}
