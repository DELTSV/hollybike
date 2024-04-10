terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "local" {
    path = ".terraform.tfstate"
  }
}

resource "aws_s3_bucket" "tfstate_bucket" {
  bucket = "tfstate-bucket-323827"

  tags = {
    Name = "tfstate-bucket"
    key  = "tfstate"
  }
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_access_key
}
