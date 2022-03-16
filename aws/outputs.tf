output "frontend_url" {
  value = "https://${module.frontend.cloudfront_domain_name}"
}

output "frontend_storage_url" {
  value = "https://${module.frontend.s3_domain_name}"
}

output "backend_url" {
  value = module.backend.apigateway_url
}

output "backend_analyze_api" {
  value = module.backend.apigateway_analyze_route
}

output "backend_function_url" {
  value = "not applicable to AWS"
}
