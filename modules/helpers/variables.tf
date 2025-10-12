variable "cloud_code" {
  description = "A short code representing the cloud provider, e.g., 'az' for Azure."
  type        = string
  default     = "az"
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