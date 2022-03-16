output "function_https_trigger" {
  value = google_cloudfunctions_function.backend.https_trigger_url
}

output "apigateway_url" {
  value = google_api_gateway_gateway.function.default_hostname
}
