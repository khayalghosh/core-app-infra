
variable "resource_group_name" {
  type        = string
  nullable    = false
  description = "The name of the resource group where the resource should be created."
}

variable "name" {
  nullable    = false
  type        = string
  description = "Key Vault name in Azure"
  validation {
    condition     = length(var.name) <= 24
    error_message = "The length of the name of this resource must be within allowed number."
  }
}

variable "location" {
  nullable    = false
  description = "The location where this resource should be created."
  type        = string
}

variable "sku_name" {
  nullable    = false
  type        = string
  description = "SKU name for keyvault"
  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "The sku you provided is not allowed. you need choose sku value from 'standard or premium'."
  }
}

variable "soft_delete_retention_days" {
  nullable    = false
  type        = number
  description = "Soft delete retention days for keyvault"
  default = 7
}

variable "purge_protection_enabled" {
  nullable    = false
  type        = bool
  description = "Purge protection enabled"
}

variable "tags" {
  nullable    = false
  type        = map(any)
  description = "The tags that are to be applied to the resource."
}

variable "enable_rbac_authorization" {
  nullable    = false
  default     = true
  type        = bool
  description = "Enable RBAC authorization"
}

variable "target_resource_id" {
  type        = string
  description = "The ID of an existing Resource on which to configure Diagnostic Settings."
  nullable    = false
  default     = ""
}

variable "storage_account_id" {
  type        = string
  description = "The ID of an existing Resource on which to configure Diagnostic Settings."
  nullable    = true
  default     = null
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Specifies the ID of a Log Analytics Workspace where Diagnostics Data should be sent."
  nullable    = true
  default     = null
}

variable "partner_solution_id" {
  type        = string
  description = "The ID of the market partner solution where Diagnostics Data should be sent."
  nullable    = true
  default     = null
}

variable "enabled_log_category" {
  description = "The name of a Diagnostic Log Category for this Resource."
  type        = string
  nullable    = false
  default     = "AuditEvent"
}

variable "enabled_log_retention_policy" {
  description = "Whether log retention policy required."
  type        = bool
  nullable    = false
  default     = true
}

variable "metric_category" {
  description = "The name of a Diagnostic Metric Category for this Resource."
  type        = string
  nullable    = false
  default     = "AllMetrics"
}

variable "metric_retention_policy" {
  description = "whether metric retention policy required."
  type        = bool
  nullable    = false
  default     = false
}

variable "public_network_access_enabled" {
  description = "whether public network access enabled."
  type        = bool
  nullable    = false
  default     = false
}

variable "virtual_network_subnet_ids" {
  type        = list(string)
  nullable    = true
  description = "Subnet Id(s) of AKS which needs to be whitelisted"
  default     = []
}

variable "key_permissions" {
  type        = list(string)
  nullable    = true
  description = "Key permissions"
  default     = ["Get"]
}
