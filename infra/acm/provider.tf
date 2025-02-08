provider "aws" {
  alias  = "default"
  region = var.region

  default_tags {
    tags = {
      Product = var.product
      Env     = var.env
    }
  }
}

# CloudFrontで使用する証明書は us-east-1 (バージニア北部) に作成する必要があるため、
# `cloudfront` という別のエイリアスを定義し、専用のawsプロバイダーを作成
provider "aws" {
  alias  = "cloudfront"
  region = var.cloud_front_region

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
    key    = "acm/terraform.tfstate"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}
