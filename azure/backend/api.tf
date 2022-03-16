# azure api management
resource "azurerm_api_management" "backend" {
  name                = "${var.project}-api"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  tags                = var.tags

  publisher_name  = var.publisher.name
  publisher_email = var.publisher.email
  sku_name        = "Consumption_0"

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_api_management_api" "backend" {
  name                = "${var.project}-api-public"
  api_management_name = azurerm_api_management.backend.name
  resource_group_name = var.resource_group.name

  revision     = "1"
  display_name = "${var.project}-api"
  path         = "api"
  protocols    = ["https"]
  # azurerm_windows_function_app.rest_api.default_hostname is empty
  # service_url           = "https://${azurerm_windows_function_app.rest_api.default_hostname}/api"
  service_url           = "https://${azurerm_windows_function_app.backend.name}.azurewebsites.net/api"
  subscription_required = false

  import {
    content_format = "openapi"
    content_value = templatefile("${path.root}/../common/api/openapi.yaml", {
      INTEGRATION = ""
    })
  }
}
