terraform {
  required_version = ">= 1.13"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.69.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-albums-shared"
    storage_account_name = "stalbumstfstate"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}