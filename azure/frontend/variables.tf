variable "project" {
  type = string
}

variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
}

variable "tags" {
  type = map(string)
}

variable "api_management_gateway_url" {
  type = string
}
