output "repository_urls" {
  description = "Map of service names to their ECR repository URLs"
  value       = { for k, v in aws_ecr_repository.this : k => v.repository_url }
}
