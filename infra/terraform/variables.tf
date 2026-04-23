variable "app_name" {
  description = "value"
  type        = string
  default     = "albums"

}
variable "environment" {
  description = ""
  type        = string
  default     = "dev"
}

variable "location" {
  description = "The location where resources will be created."
  type        = string
  default     = "West Europe"
}

variable "tags" {
  type        = map(string)
  description = ""
  default     = {}
}