locals {
  display_name = "${var.project}-api"
}

# enable api service
resource "google_project_service" "api_gateway" {
  project = var.project
  service = "apigateway.googleapis.com"

  disable_dependent_services = true
}

resource "google_service_account" "function" {
  project = var.project
  # cut down project name, if account_id would be longer than 24 characters
  account_id = "${substr(var.project, 0, 12)}-api-gateway"
}

resource "google_api_gateway_api" "function" {
  provider = google-beta
  api_id   = var.project
  project  = var.project
}

resource "google_api_gateway_api_config" "function" {
  provider = google-beta
  project  = var.project

  api = google_api_gateway_api.function.api_id

  gateway_config {
    backend_config {
      google_service_account = google_service_account.function.email
    }
  }

  openapi_documents {
    document {
      path = "openapi.yaml"
      contents = base64encode(templatefile("${path.root}/../common/api/swagger.yaml", {
        INTEGRATION = <<EOL
operationId: analyze
      x-google-backend:
        address: ${google_cloudfunctions_function.backend.https_trigger_url}
        EOL
      }))
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_api_gateway_gateway" "function" {
  provider = google-beta
  region   = var.region
  project  = var.project

  api_config = google_api_gateway_api_config.function.id

  gateway_id = "${var.project}-api-gateway"

  depends_on = [google_api_gateway_api_config.function]
}
