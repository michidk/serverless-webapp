resource "azurerm_cdn_profile" "frontend" {
  name                = "${var.project}-profile"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  tags                = var.tags

  sku = "Standard_Microsoft"
}

resource "azurerm_cdn_endpoint" "frontend" {
  name                = "${var.project}-endpoint"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  tags                = var.tags

  profile_name                  = azurerm_cdn_profile.frontend.name
  origin_host_header            = azurerm_storage_account.website.primary_web_host
  querystring_caching_behaviour = "IgnoreQueryString"

  origin {
    name      = "websiteorginaccount"
    host_name = azurerm_storage_account.website.primary_web_host
  }

}
