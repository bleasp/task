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

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.app_name}-${var.environment}"
  location = var.location
  tags     = local.tags
}

resource "azurerm_log_analytics_workspace" "log" {
  name                = "log-${var.app_name}-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "cae" {
  name                = "cae-${var.app_name}-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

resource "azurerm_role_assignment" "role" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_container_app.ca.identity[0].principal_id
}

resource "azurerm_container_app" "ca" {
  name                         = "ca-${var.app_name}-${var.environment}"
  container_app_environment_id = azurerm_container_app_environment.cae.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"
  tags                         = local.tags

  registry {
    server   = azurerm_container_registry.acr.login_server
    identity = "system"
  }

  identity {
    type = "SystemAssigned"
  }

  ingress {
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
    target_port      = 80
    external_enabled = false
  }

  template {
    min_replicas = var.ca_config.min_replicas
    max_replicas = var.ca_config.max_replicas
    container {
      name   = "${var.app_name}-app"
      image  = "${azurerm_container_registry.acr.login_server}/bleasp/task:${var.image_tag}"
      cpu    = var.ca_config.cpu
      memory = var.ca_config.memory
    }
  }
}
