output "cloudfront" {
  value = {
    id   = aws_acm_certificate.cloudfront.id
    arn  = aws_acm_certificate.cloudfront.arn
    name = aws_acm_certificate.cloudfront.domain_name
  }
}
