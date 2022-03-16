provider "google" {
  project = var.project
  region  = var.region
}

module "backend" {
  source = "./backend"

  project  = var.project
  region   = var.region
  location = var.location
  tags     = var.tags
}

module "frontend" {
  source = "./frontend"

  project  = var.project
  region   = var.region
  location = var.location
  tags     = var.tags

  apigateway_url = module.backend.apigateway_url
}
