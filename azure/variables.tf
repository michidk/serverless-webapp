variable "project" {
  type        = string
  description = "Name of the project"
}

variable "location" {
  type        = string
  description = "The location of the resource group"
  default     = "North Central US"
}

variable "publisher" {
  type = object({
    name  = string
    email = string
  })
  default = {
    name  = "Awesome Company",
    email = "mail@test.com"
  }
  description = "The publisher required for the APIM"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
  default     = {}
}
