data "terraform_remote_state" "route53" {
  backend = "s3"
  config = {
    bucket = "dev-react-vite-sample-tfstate"
    key    = "route53/terraform.tfstate"
  }
}
