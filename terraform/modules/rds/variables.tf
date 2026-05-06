variable "project" {
  description = "Project short code"
  type        = string
}

variable "environment" {
  description = "Environment (dev, prod)"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the DB Subnet Group"
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "Security Group IDs to attach to the RDS instance"
  type        = list(string)
}

variable "db_name" {
  description = "Name of the initial database"
  type        = string
  default     = "petclinic"
}

variable "db_username" {
  description = "Master username for the database"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
}
