output "function_app_default_hostname" {
  value = "https://${azurerm_windows_function_app.backend.name}.azurewebsites.net/api"
}

output "api_management_gateway_url" {
  value = "${azurerm_api_management.backend.gateway_url}/${azurerm_api_management_api.backend.path}"
}

output "api_management_gateway_analyze_api" {
  value = "${azurerm_api_management.backend.gateway_url}/${azurerm_api_management_api.backend.path}/analyze"
}
