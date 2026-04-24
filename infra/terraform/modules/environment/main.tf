resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.app_name}-${var.environment}"
  location = var.location
  tags     = var.tags
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
  tags                = var.tags
}

resource "azurerm_role_assignment" "role" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_container_app.ca.identity[0].principal_id
}

resource "azurerm_container_app" "ca" {
  name                         = "ca-${var.app_name}-${var.environment}"
  container_app_environment_id = azurerm_container_app_environment.cae.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"
  tags                         = var.tags

  registry {
    server   = var.acr_login_server
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
      image  = "${var.acr_login_server}/bleasp/task:${var.image_tag}"
      cpu    = var.ca_config.cpu
      memory = var.ca_config.memory
    }
  }
}
