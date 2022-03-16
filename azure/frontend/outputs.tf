output "cdn_endpoint" {
  value = one(azurerm_cdn_endpoint.frontend.origin[*].host_name)
}

output "storage_id" {
  value = azurerm_storage_container.website.id
}
