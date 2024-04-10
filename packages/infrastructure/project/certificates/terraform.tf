#
# provider "aws" {
#   alias      = "virginia"
#   region     = "us-east-1"
#   access_key = var.access_key
#   secret_key = var.secret_access_key
# }

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"

      configuration_aliases = [aws.virginia]
    }
  }
}