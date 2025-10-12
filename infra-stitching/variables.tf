variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
  
}

variable "environment" {
  description = "The deployment environment, e.g., 'dev', 'staging', 'prod'."
  type        = string
  default     = "dev"
}

variable "project" {
  description = "The name of the project or application."
  type        = string
  default     = "myapp"
  
}

variable "cloud_code" {
  description = "A short code representing the cloud provider, e.g., 'az' for Azure."
  type        = string
  default     = "az"
  
}

## Virtual Network and Subnet Variables
variable "vnet_address_space" {
    description = "The address space to use for the virtual network."
    type        = list(string)
    default     = ["10.0.0.0/16"]

}
variable "subnet_address_prefixes" {
  description = "The address prefixes to use for the subnet."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

# Key Vault Variables
variable "location" {
  description = "The Azure region where resources will be deployed."
  type        = string
  default     = "East US"
}
