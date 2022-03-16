locals {
  file = "function.zip"
}

# gather function lib and abstraction in the same folder
resource "local_file" "function_lib" {
  for_each = fileset("${path.root}/../common/function/", "**")

  source   = "${path.root}/../common/function/${each.key}"
  filename = "${path.module}/function/${each.key}"
}

data "archive_file" "function" {
  type        = "zip"
  source_dir  = "${path.module}/function"
  output_path = "${path.module}/${local.file}"

  depends_on = [
    local_file.function_lib
  ]
}

resource "google_storage_bucket" "function" {
  name     = "${var.project}-function"
  location = var.location
}

resource "google_storage_bucket_object" "function" {
  name   = local.file
  bucket = google_storage_bucket.function.name
  source = data.archive_file.function.output_path
}
