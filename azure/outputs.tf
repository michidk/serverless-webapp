output "frontend_url" {
  value = "https://${module.frontend.cdn_endpoint}"
}

output "frontend_storage_url" {
  value = module.frontend.storage_id
}

output "backend_url" {
  value = module.backend.api_management_gateway_url
}

output "backend_analyze_api" {
  value = module.backend.api_management_gateway_analyze_api
}

output "backend_function_url" {
  value = module.backend.function_app_default_hostname
}
