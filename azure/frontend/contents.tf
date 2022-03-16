locals {
  mime_types = jsondecode(file("${path.root}/../common/mime-types.json"))
}

resource "azurerm_storage_account" "website" {
  name                = "${replace(var.project, "-", "")}sa"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  tags                = var.tags

  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true

  static_website {
    index_document = "index.html"
  }
}

resource "azurerm_storage_container" "website" {
  name = "${var.project}-website"

  storage_account_name  = azurerm_storage_account.website.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "website" {
  for_each = fileset("${path.root}/../common/website/", "**")

  name                   = each.key
  storage_account_name   = azurerm_storage_account.website.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = lookup(local.mime_types, split(".", each.value)[length(split(".", each.value)) - 1])
  source                 = "${path.root}/../common/website/${each.key}"
  content_md5            = filemd5("${path.root}/../common/website/${each.key}")
}

# generate conf.js containing the backend url
resource "azurerm_storage_blob" "website-conf" {
  name                   = "conf.js"
  storage_account_name   = azurerm_storage_account.website.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "application/javascript"
  source_content         = "var BACKEND_API = \"${var.api_management_gateway_url}\""
}
