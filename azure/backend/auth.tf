# ensures that the function can only be called from the APIM
resource "azuread_application" "backend" {
  display_name            = "${var.project}-app"
  prevent_duplicate_names = true
}

resource "azurerm_api_management_api_policy" "backend" {
  api_name            = azurerm_api_management_api.backend.name
  api_management_name = azurerm_api_management.backend.name
  resource_group_name = var.resource_group.name

  xml_content = <<XML
<policies>
  <inbound>
    <base />
    <authentication-managed-identity resource="${azuread_application.backend.application_id}" ignore-error="false" />
  </inbound>
</policies>
XML
}

data "azurerm_client_config" "backend" {}

# gives function deployment access to the storage blob storing the function code
# storage account to access function code
data "azurerm_storage_account_blob_container_sas" "backend" {
  connection_string = azurerm_storage_account.function.primary_connection_string
  container_name    = azurerm_storage_container.function.name
  https_only        = true
  start             = "2022-01-01"
  expiry            = "2050-12-31"

  permissions {
    read   = true
    add    = false
    create = false
    write  = false
    delete = false
    list   = false
  }
}
