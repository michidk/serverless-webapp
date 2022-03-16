locals {
  file = "function.zip"
}

resource "aws_s3_bucket" "function" {
  tags          = var.tags
  bucket        = "${var.project}-function"
  force_destroy = "false"
}

# block all public access
resource "aws_s3_bucket_public_access_block" "function" {
  bucket = aws_s3_bucket.function.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
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

resource "aws_s3_object" "function" {
  tags   = var.tags
  bucket = aws_s3_bucket.function.bucket
  key    = local.file
  source = data.archive_file.function.output_path
}
