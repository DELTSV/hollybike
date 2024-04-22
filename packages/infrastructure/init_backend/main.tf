terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }

  backend "local" {
    path = ".terraform.tfstate"
  }
}

resource "scaleway_object_bucket" "tfstate_bucket" {
  name = "hollybike-terraformstate"
  tags = {
    key = "tfstate"
  }
}

provider "scaleway" {
  access_key = var.access_key_id
  secret_key = var.secret_key
  project_id = var.project_id
}