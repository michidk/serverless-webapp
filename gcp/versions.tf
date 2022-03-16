terraform {
  required_version = ">= 1.1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.15.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.15.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.2.2"
    }
  }
}
