provider "azurerm" {
  features {}
}


provider "azuread" {

}

resource "azurerm_resource_group" "rg" {
  name     = var.project
  location = var.location
}

module "backend" {
  source = "./backend"

  project        = var.project
  resource_group = azurerm_resource_group.rg
  publisher      = var.publisher
  tags           = var.tags
}

module "frontend" {
  source = "./frontend"

  project        = var.project
  resource_group = azurerm_resource_group.rg
  tags           = var.tags

  api_management_gateway_url = module.backend.api_management_gateway_url
}
