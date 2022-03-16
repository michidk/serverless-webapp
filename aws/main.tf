provider "aws" {
  region = var.region
}

module "backend" {
  source = "./backend"

  project = var.project
  tags    = var.tags
}

module "frontend" {
  source = "./frontend"

  project = var.project
  tags    = var.tags

  apigateway_url = module.backend.apigateway_url
}
