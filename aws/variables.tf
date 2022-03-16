variable "project" {
  type        = string
  description = "The name of the project"
}

variable "region" {
  type        = string
  description = "The region to deploy in"
  default     = "us-east-1"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
  default     = {}
}
