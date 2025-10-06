#############################################################################
# VARIABLES
#############################################################################

variable "resource_group_name" {
  type        = string
  nullable    = false
  description = "The name of the resource group we want to use"
}

variable "tags" {
  type        = map(any)
  nullable    = false
  default = {
    source = "terraform",
    created_by = "khayal",
    type = "virtual_network",
    idp = "core-app-infra"
  }
  description = "The tags to associate the resource we are creating"
}

variable "name" {
  type        = string
  nullable    = false
  description = "Name of the vnet to create"
  validation {
    condition     = length(var.name) <= 64
    error_message = "The length of the name of this resource must be within allowed number."
  }
}

variable "address_space" {
  type        = list(string)
  nullable    = false
  default     = []
  description = "The address space that is used by the virtual network."
}

variable "location" {
  nullable    = false
  description = "The location where this resource should be created."
  type        = string
  # Regular validation is not needed since terraform will check for valid options at terraform plan
}

variable "ddos_protection_plan_id" {
  type        = string
  nullable    = false
  description = "The id of the Network DDoS Protection Plan."
}