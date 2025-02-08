data "terraform_remote_state" "cloudfront" {
  backend = "s3"
  config = {
    bucket = "${var.env}-react-vite-sample-tfstate"
    key    = "cloudfront/terraform.tfstate"
  }
}
