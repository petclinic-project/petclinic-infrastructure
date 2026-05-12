
output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "ecr_repository_urls" {
  value = module.ecr.repository_urls
}

output "rds_endpoint" {
  value = module.rds.db_endpoint

}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.eks.arn
}
