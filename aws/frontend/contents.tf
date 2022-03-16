locals {
  mime_types = jsondecode(file("${path.root}/../common/mime-types.json"))
}

resource "aws_s3_bucket" "website" {
  bucket        = "${var.project}-website"
  force_destroy = "false"
}

resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "website" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.frontend.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.website.json
}

resource "aws_s3_object" "website" {
  for_each = fileset("${path.root}/../common/website/", "**")

  bucket       = aws_s3_bucket.website.bucket
  key          = each.key
  source       = "${path.root}/../common/website/${each.key}"
  source_hash  = filemd5("${path.root}/../common/website/${each.key}")
  content_type = lookup(local.mime_types, split(".", each.value)[length(split(".", each.value)) - 1])
}

# generate conf.js containing the backend url
resource "aws_s3_object" "website-conf" {
  bucket       = aws_s3_bucket.website.bucket
  key          = "conf.js"
  content_type = "application/javascript"
  content      = "var BACKEND_API = \"${var.apigateway_url}\""
}
