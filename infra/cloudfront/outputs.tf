output "web_front" {
  value = {
    arn            = aws_cloudfront_distribution.web_front.arn
    hosted_zone_id = aws_cloudfront_distribution.web_front.hosted_zone_id
    domain_name    = aws_cloudfront_distribution.web_front.domain_name
  }
}
