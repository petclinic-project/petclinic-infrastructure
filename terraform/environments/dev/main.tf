module "vpc" {
  source = "../../modules/vpc"

  project        = var.project
  environment    = var.environment
  vpc_cidr       = var.vpc_cidr
  azs            = var.azs
  public_subnets = var.public_subnets
}
