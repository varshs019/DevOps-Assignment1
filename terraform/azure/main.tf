# ------------------------------------------------------------------------------
# Resource Group
# ------------------------------------------------------------------------------
resource "azurerm_resource_group" "main" {
  name     = "${var.project_name}-${var.environment}-rg"
  location = var.location
}

# ------------------------------------------------------------------------------
# Azure Container Registry
# ------------------------------------------------------------------------------
resource "azurerm_container_registry" "main" {
  name                = replace("${var.project_name}${var.environment}acr", "-", "")
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = var.environment == "prod" ? "Standard" : "Basic"
  admin_enabled       = true
}

# ------------------------------------------------------------------------------
# Log Analytics Workspace (for Container Apps)
# ------------------------------------------------------------------------------
resource "azurerm_log_analytics_workspace" "main" {
  name                = "${var.project_name}-${var.environment}-log"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = var.environment == "prod" ? 30 : 7
}

# ------------------------------------------------------------------------------
# Container Apps Environment
# ------------------------------------------------------------------------------
resource "azurerm_container_app_environment" "main" {
  name                       = "${var.project_name}-${var.environment}-env"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
}

# ------------------------------------------------------------------------------
# Backend Container App
# ------------------------------------------------------------------------------
resource "azurerm_container_app" "backend" {
  name                         = "${var.project_name}-${var.environment}-backend"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"

  template {
    min_replicas = var.environment == "prod" ? 2 : 0
    max_replicas = var.environment == "prod" ? 10 : 3

    container {
      name   = "backend"
      image  = var.backend_image != "" ? var.backend_image : "${azurerm_container_registry.main.login_server}/${var.project_name}-backend:latest"
      cpu    = var.environment == "prod" ? 0.5 : 0.25
      memory = "0.5Gi"

      liveness_probe {
        path      = "/api/health"
        port      = 8000
        transport = "HTTP"
        initial_delay           = 10
        interval_seconds        = 30
        timeout                 = 5
        failure_count_threshold = 3
      }

      readiness_probe {
        path      = "/api/health"
        port      = 8000
        transport = "HTTP"
        interval_seconds        = 10
        timeout                 = 5
        success_count_threshold = 1
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = 8000
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  registry {
    server               = azurerm_container_registry.main.login_server
    username             = azurerm_container_registry.main.admin_username
    password_secret_name = "acr-password"
  }

  secret {
    name  = "acr-password"
    value = azurerm_container_registry.main.admin_password
  }
}

# ------------------------------------------------------------------------------
# Frontend Container App
# ------------------------------------------------------------------------------
resource "azurerm_container_app" "frontend" {
  name                         = "${var.project_name}-${var.environment}-frontend"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"

  template {
    min_replicas = var.environment == "prod" ? 2 : 0
    max_replicas = var.environment == "prod" ? 10 : 3

    container {
      name   = "frontend"
      image  = var.frontend_image != "" ? var.frontend_image : "${azurerm_container_registry.main.login_server}/${var.project_name}-frontend:latest"
      cpu    = var.environment == "prod" ? 0.5 : 0.25
      memory = "0.5Gi"

      # Note: NEXT_PUBLIC_API_URL must be set at image build time for Next.js client.
      # Build frontend with: NEXT_PUBLIC_API_URL=https://<backend-fqdn>
    }
  }

  ingress {
    external_enabled = true
    target_port      = 3000
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  registry {
    server               = azurerm_container_registry.main.login_server
    username             = azurerm_container_registry.main.admin_username
    password_secret_name = "acr-password"
  }

  secret {
    name  = "acr-password"
    value = azurerm_container_registry.main.admin_password
  }

  depends_on = [azurerm_container_app.backend]
}
