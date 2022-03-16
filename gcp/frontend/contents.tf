locals {
  mime_types = jsondecode(file("${path.root}/../common/mime-types.json"))
}

resource "google_storage_bucket" "website" {
  name     = "${var.project}-website"
  location = var.location

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

data "google_iam_policy" "viewer" {
  binding {
    role = "roles/storage.objectViewer"
    members = [
      "allUsers",
    ]
  }
}

resource "google_storage_bucket_iam_policy" "website" {
  bucket      = google_storage_bucket.website.name
  policy_data = data.google_iam_policy.viewer.policy_data
}

resource "google_storage_bucket_object" "website" {
  for_each = fileset("${path.root}/../common/website/", "**")

  name         = each.key
  bucket       = google_storage_bucket.website.name
  source       = "${path.root}/../common/website/${each.key}"
  content_type = lookup(local.mime_types, split(".", each.value)[length(split(".", each.value)) - 1])
}

# generate conf.js containing the backend url
resource "google_storage_bucket_object" "website-conf" {
  bucket       = google_storage_bucket.website.name
  name         = "conf.js"
  content_type = "application/javascript"
  content      = "var BACKEND_API = \"https://${var.apigateway_url}/api\""
}
