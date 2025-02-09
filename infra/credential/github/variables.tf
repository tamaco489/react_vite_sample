variable "env" {
  description = "The environment in which the OIDC IAM Role will be created"
  type        = string
  default     = "dev"
}

variable "product" {
  description = "The product name"
  type        = string
  default     = "react-vite-sample"
}

variable "region" {
  description = "The region in which the OIDC IAM Role will be created"
  type        = string
  default     = "ap-northeast-1"
}

variable "github_actions_oidc_provider_arn" {
  description = "The ARN of the OpenID Connect (OIDC) identity provider that is trusted by the Kubernetes API server"
  type        = string
  default     = ""
}

locals {
  fqn = "${var.env}-${var.product}"
}
