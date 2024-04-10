terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket = "tfstate-bucket-323827"
    key    = "terraform.tfstate"
    region = "eu-west-3"
  }
}