######################
## Shared resources ##
######################

resource "azurerm_resource_group" "rg_shared" {
  name     = "rg-${var.app_name}-shared"
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                = "acrra${var.app_name}"
  resource_group_name = azurerm_resource_group.rg_shared.name
  location            = azurerm_resource_group.rg_shared.location
  sku                 = "Basic"
}

####################################
## Environment-specific resources ##
####################################

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.app_name}-${var.environment}"
  location = var.location
  tags     = local.tags
}
