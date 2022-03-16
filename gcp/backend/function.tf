# Enable Cloud Functions API
resource "google_project_service" "cloud_function" {
  project = var.project
  service = "cloudfunctions.googleapis.com"

  disable_dependent_services = true
}

# Enable Cloud Build API
resource "google_project_service" "cloud_build" {
  project = var.project
  service = "cloudbuild.googleapis.com"

  disable_dependent_services = true
}


resource "google_cloudfunctions_function" "backend" {
  name    = "analyze"
  project = var.project
  region  = var.region

  description           = "${var.project}-function"
  runtime               = "nodejs14"
  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.function.name
  source_archive_object = google_storage_bucket_object.function.name
  trigger_http          = true
  entry_point           = "handler"
}

# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = var.project
  region         = google_cloudfunctions_function.backend.region
  cloud_function = google_cloudfunctions_function.backend.name

  role   = "roles/cloudfunctions.invoker"
  member = "serviceAccount:${google_service_account.function.email}"
}
