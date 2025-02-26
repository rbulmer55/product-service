variable "environment" {
  description = "The environment using the resource"
  type        = string
}

variable "mongodbatlas_project_id" {
  description = "Atlas Project Id"
  type        = string
}

variable "application_ip_address" {
  description = "Application ip addresses for whitelist"
  type        = string
}
