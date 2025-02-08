variable "env" {
  description = "The environment in which the CloudFront will be created"
  type        = string
  default     = "dev"
}

variable "product" {
  description = "The product name"
  type        = string
  default     = "react-vite-sample"
}

variable "region" {
  description = "The region in which the CloudFront will be created"
  type        = string
  default     = "ap-northeast-1"
}

# cloudfrontのSSL/TLS証明書などはバージニア北部リージョンで作成する必要がある
variable "cloud_front_region" {
  description = "The cloudfront configuration needs to be created in the Northern Virginia Region."
  type        = string
  default     = "us-east-1"
}

variable "web_front_domain" {
  description = "The domain name for CloudFront of web front"
  type        = string
  default     = ""
}

locals {
  fqn = "${var.env}-${var.product}"
}

