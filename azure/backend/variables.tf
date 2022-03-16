variable "project" {
  type = string
}

variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
}

variable "publisher" {
  type = object({
    name  = string
    email = string
  })
}

variable "tags" {
  type = map(string)
}
