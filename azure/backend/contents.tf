# gather function lib and abstraction in the same folder
resource "local_file" "function_lib" {
  # all files but package.json
  for_each = {
    for k, v in fileset("${path.root}/../common/function/", "**") : k => v
    if k != "package.json"
  }

  source   = "${path.root}/../common/function/${each.key}"
  filename = "${path.module}/function/analyze/${each.key}"
}

# package.json
resource "local_file" "function_lib_package" {
  source   = "${path.root}/../common/function/package.json"
  filename = "${path.module}/function/package.json"
}

data "archive_file" "function" {
  type        = "zip"
  source_dir  = "${path.module}/function"
  output_path = "${path.module}/function.zip"

  depends_on = [
    local_file.function_lib,
    local_file.function_lib_package
  ]
}

resource "azurerm_storage_account" "function" {
  name                = "${replace(var.project, "-", "")}fn"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  tags                = var.tags

  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "function" {
  name                  = "${var.project}-functions"
  storage_account_name  = azurerm_storage_account.function.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "function" {
  name = "function.zip"

  storage_account_name   = azurerm_storage_account.function.name
  storage_container_name = azurerm_storage_container.function.name
  type                   = "Block"
  source                 = data.archive_file.function.output_path
  content_md5            = filemd5(data.archive_file.function.output_path)
}
