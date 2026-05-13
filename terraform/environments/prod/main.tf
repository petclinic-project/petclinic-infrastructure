module "vpc" {
  source = "../../modules/vpc"

  project         = var.project
  environment     = var.environment
  vpc_cidr        = var.vpc_cidr
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "eks" {
  source = "../../modules/eks"

  project         = var.project
  environment     = var.environment
  cluster_version = var.cluster_version

  # Injecting network outputs from the VPC module
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.public_subnet_ids
  cluster_sg_id      = module.vpc.eks_cluster_sg_id
  private_subnet_ids = module.vpc.private_subnet_ids
}


module "ecr" {
  source = "../../modules/ecr"

  project     = var.project
  environment = var.environment

  service_names = [
    "config-server",
    "discovery-server",
    "api-gateway",
    "customers-service",
    "visits-service",
    "vets-service",
    "genai-service",
    "admin-server"
  ]
}

# Task 3: Generate a secure, random password
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Task 2: Instantiate the RDS Module
module "rds" {
  source = "../../modules/rds"

  project                = var.project
  environment            = var.environment
  subnet_ids             = module.vpc.private_subnet_ids
  vpc_security_group_ids = [module.vpc.rds_sg_id]
  db_password            = random_password.db_password.result
}

# Task 1 (Sprint 4): Store RDS Credentials in Secrets Manager
module "rds_secrets" {
  source = "../../modules/secrets"

  project            = var.project
  environment        = var.environment
  secret_name_suffix = "rds-credentials"

  secret_payload = {
    username = "admin"
    password = random_password.db_password.result
    host     = module.rds.db_endpoint
  }
}
