provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Product = var.product
      Env     = var.env
    }
  }
}

terraform {
  required_version = "1.9.5"
  backend "s3" {
    bucket = "dev-react-vite-sample-tfstate"
    key    = "credential/sops/terraform.tfstate"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}
