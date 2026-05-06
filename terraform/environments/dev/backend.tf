terraform {
  backend "s3" {
    bucket       = "pc-tfstate-482352877891-ap-south-1"
    key          = "petclinic/dev/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
