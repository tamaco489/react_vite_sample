# CloudFront の Origin Access Control (OAC) を設定
# OAC: CloudFront -> S3 バケットにアクセスする際の認証を管理するために使用。このリソースにより CloudFront -> S3 バケットへのアクセスを制御する。
#
# Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control
resource "aws_cloudfront_origin_access_control" "web_front" {
  name                              = "${var.env}-react-vite-sample-web-front"
  description                       = "origin access controll for ${var.env} web front"

  # CloudFront のオリジンのタイプを `s3` に指定。つまり、アクセス制御が S3 バケットに対して設定されていることを意味する。
  # CloudFront からのリクエストが S3 バケットへ向かう場合、この設定が適用される。※他にはlambda, mediapackagev2, mediastore の指定が可能。
  origin_access_control_origin_type = "s3"

  # CloudFront がリクエストをオリジンに転送する際に、リクエストの署名の扱いを `always` に指定。
  # always: CloudFront からのすべてのリクエストに対して署名を行う。※セキュリティレベルを高めるため、常に署名が必要となるように設定。
  signing_behavior                  = "always"

  # 署名プロトコルを `sigv4` に指定。※現時点で `sigv4` 以外の署名プロトコルを指定することは不可能。
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "web_front" {
  origin {
    domain_name              = data.terraform_remote_state.s3.outputs.web_front.bucket_regional_domain_name
    origin_id                = data.terraform_remote_state.s3.outputs.web_front.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.web_front.id
  }

  enabled             = true
  default_root_object = "index.html"
  is_ipv6_enabled     = true
  comment             = "react vite sample web front"
  aliases             = [var.web_front_domain]

  custom_error_response {
    error_caching_min_ttl = 60
    error_code            = 403
    response_code         = 200
    response_page_path    = "/"
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = data.terraform_remote_state.s3.outputs.web_front.bucket_regional_domain_name
    compress               = true
    cache_policy_id        = data.aws_cloudfront_cache_policy.caching_optimized.id
    viewer_protocol_policy = "https-only"

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.web_front.arn
    }
  }

  price_class = "PriceClass_200"
  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  web_acl_id = aws_wafv2_web_acl.web_front.arn

  viewer_certificate {
    acm_certificate_arn            = data.terraform_remote_state.acm.outputs.cloudfront.arn
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  tags       = { Name = "${local.fqn}-web-front" }
}
