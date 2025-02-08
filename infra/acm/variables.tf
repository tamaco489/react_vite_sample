variable "env" {
  description = "The environment in which the ACM will be created"
  type        = string
  default     = "dev"
}

variable "product" {
  description = "The product name"
  type        = string
  default     = "react-vite-sample"
}

variable "region" {
  description = "The region in which the ACM will be created"
  type        = string
  default     = "ap-northeast-1"
}

variable "cloud_front_region" {
  description = "The region in which CloudFront will be used"
  type        = string
  default     = "us-east-1"
}

variable "domain" {
  description = "The domain name"
  type        = string
  default     = "example.com"
}

locals {
  fqn = "${var.env}-${var.product}"
}
