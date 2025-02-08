variable "env" {
  description = "The environment in which the KMS will be created"
  type        = string
  default     = "dev"
}

variable "product" {
  description = "The product name"
  type        = string
  default     = "react-vite-sample"
}

variable "region" {
  description = "The region in which the KMS will be created"
  type        = string
  default     = "ap-northeast-1"
}

locals {
  fqn = "${var.env}-${var.product}"
}
