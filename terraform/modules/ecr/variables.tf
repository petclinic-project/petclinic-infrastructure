variable "project" {
  description = "Project short code"
  type        = string
}

variable "environment" {
  description = "Environment (dev, prod)"
  type        = string
}

variable "service_names" {
  description = "List of microservice names to create repositories for"
  type        = list(string)
}

variable "image_mutability" {
  description = "Whether image tags can be overwritten"
  type        = string
  default     = "MUTABLE" # Useful for dev environments
}
