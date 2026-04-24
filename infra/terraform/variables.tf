variable "app_name" {
  description = "Name of the application used for naming Azure resources."
  type        = string
  default     = "albums"
}

variable "environment" {
  description = "Deployment environment for the resources (e.g., dev, prod)."
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure location where all resources will be deployed."
  type        = string
  default     = "West Europe"
}
variable "image_tag" {
  type        = string
  description = "The image tag/SHA to deploy. Passed from the GitHub Actions CI/CD pipeline."
}


variable "tags" {
  description = "A map of key-value pairs used to tag resources for organization."
  type        = map(string)
  default     = {}
}