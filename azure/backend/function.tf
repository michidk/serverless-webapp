resource "azurerm_service_plan" "backend" {
  name                = "${var.project}-plan"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  tags                = var.tags

  # windows consumption plan
  os_type  = "Windows"
  sku_name = "D1"
}

resource "azurerm_application_insights" "backend" {
  name                = "${var.project}-insights"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  tags                = var.tags

  application_type = "web"
}

resource "azurerm_windows_function_app" "backend" {
  name                = "${var.project}-app"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  tags                = var.tags

  service_plan_id = azurerm_service_plan.backend.id
  site_config {}

  storage_account_name       = azurerm_storage_account.function.name
  storage_account_access_key = azurerm_storage_account.function.primary_access_key

  app_settings = {
    "https_only"                     = "true",
    "FUNCTIONS_WORKER_RUNTIME"       = "node",
    "WEBSITE_RUN_FROM_PACKAGE"       = "https://${azurerm_storage_account.function.name}.blob.core.windows.net/${azurerm_storage_container.function.name}/${azurerm_storage_blob.function.name}${data.azurerm_storage_account_blob_container_sas.backend.sas}",
    "WEBSITE_NODE_DEFAULT_VERSION"   = "~14",
    "AzureWebJobsDisableHomepage"    = "true",
    "HASH"                           = filebase64sha256(data.archive_file.function.output_path),
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.backend.instrumentation_key,
  }

  auth_settings {
    enabled          = true
    issuer           = "https://login.microsoftonline.com/${data.azurerm_client_config.backend.tenant_id}"
    default_provider = "AzureActiveDirectory"
    active_directory {
      client_id = azuread_application.backend.application_id
    }
    unauthenticated_client_action = "RedirectToLoginPage"
  }
}
