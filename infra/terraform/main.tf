######################
## Shared resources ##
######################

resource "azurerm_resource_group" "rg_shared" {
  name     = "rg-${var.app_name}-shared"
  location = var.location
}

resource "azurerm_storage_account" "st" {
  name                     = "st${var.app_name}tfstate"
  resource_group_name      = azurerm_resource_group.rg_shared.name
  location                 = azurerm_resource_group.rg_shared.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "stc" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.st.id
  container_access_type = "blob"
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

module "environment" {
  source = "./modules/environment"

  app_name    = var.app_name
  environment = var.environment
  location    = var.location
  tags        = local.tags

  acr_id           = azurerm_container_registry.acr.id
  acr_login_server = azurerm_container_registry.acr.login_server

  image_tag = var.image_tag
  ca_config = var.ca_config
}

