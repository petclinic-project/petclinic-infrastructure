terraform {
  backend "s3" {
    bucket         = "pc-tfstate-729501299157-ap-south-1"
    key            = "petclinic/dev/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "pc-tfstate-locks"
  }
}
