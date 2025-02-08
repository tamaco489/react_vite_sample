data "terraform_remote_state" "s3" {
  backend = "s3"
  config = {
    bucket = "${var.env}-react-vite-sample-tfstate"
    key    = "s3/terraform.tfstate"
  }
}

data "terraform_remote_state" "acm" {
  backend = "s3"
  config = {
    bucket = "${var.env}-react-vite-sample-tfstate"
    key    = "acm/terraform.tfstate"
  }
}

data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized"
}

data "sops_file" "web_front_secret" {
  source_file = "tfvars/${var.env}_web_front.yaml"
}
