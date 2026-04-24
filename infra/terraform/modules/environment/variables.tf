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

variable "ca_config" {
  type = object({
    min_replicas = number
    max_replicas = number
    cpu          = string
    memory       = string
  })
  default = {
    min_replicas = 1
    max_replicas = 2
    cpu          = 0.25
    memory       = "0.5Gi"
  }
  description = "Specific configuration for the target environment container app."
}


variable "tags" {
  description = "A map of key-value pairs used to tag resources for organization."
  type        = map(string)
  default     = {}
}

variable "acr_id" {
  description = "The ID of the Azure Container Registry (ACR). Used to assign AcrPull role to the Container App managed identity."
  type        = string
}

variable "acr_login_server" {
  description = "The login server (URL) of the Azure Container Registry (ACR), used for pulling container images."
  type        = string
}