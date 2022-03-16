variable "project" {
  type        = string
  description = "The name of the project"
}

variable "region" {
  type        = string
  description = "The region to deploy in"
  default     = "us-central1"
}

variable "location" {
  type        = string
  description = "The location where buckets are deployed"
  default     = "US"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
  default     = {}
}
