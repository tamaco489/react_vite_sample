variable "env" {
  description = "The environment in which the S3 Bucket will be created"
  type        = string
  default     = "dev"
}

variable "product" {
  description = "The product name"
  type        = string
  default     = "react-vite-sample"
}

locals {
  fqn = "${var.env}-${var.product}"
}
