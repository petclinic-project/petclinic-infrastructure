variable "project" {
  description = "Project short code"
  type        = string
}

variable "environment" {
  description = "Environment (dev, prod)"
  type        = string
}

variable "secret_name_suffix" {
  description = "Suffix for the secret name"
  type        = string
}

variable "secret_payload" {
  description = "A map containing the key-value pairs to store in the secret"
  type        = map(string)
}
