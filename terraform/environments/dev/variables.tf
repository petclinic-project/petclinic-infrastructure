variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

variable "project" {
  description = "Project short code"
  type        = string
  default     = "pc"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}
