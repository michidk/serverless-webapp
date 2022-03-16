output "frontend_url" {
  value = module.frontend.cdn_url
}

output "frontend_storage_url" {
  value = module.frontend.bucket_url
}

output "backend_url" {
  value = "https://${module.backend.apigateway_url}"
}

output "backend_analyze_api" {
  value = "https://${module.backend.apigateway_url}/api/analyze"
}

output "backend_function_url" {
  value = module.backend.function_https_trigger
}
