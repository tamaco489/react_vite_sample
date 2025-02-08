output "web_front" {
  value = {
    id                          = aws_s3_bucket.web_front.id
    arn                         = aws_s3_bucket.web_front.arn
    bucket                      = aws_s3_bucket.web_front.bucket
    bucket_regional_domain_name = aws_s3_bucket.web_front.bucket_regional_domain_name
  }
}
