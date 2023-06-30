terraform {
  backend "s3" {
    region               = "us-east-1"
    bucket               = "caylent-dev-tf-state-us-east-1"
    key                  = "wesley-test/encryptaurora/terraform.tfstate"
  }
}