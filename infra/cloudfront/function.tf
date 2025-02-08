resource "aws_cloudfront_function" "web_front" {
  code = templatefile("${path.module}/web-front.js", {
    auth_string = data.sops_file.web_front_secret.data.basic_auth_string,
  })
  name    = "${local.fqn}-web-front-function"
  runtime = "cloudfront-js-2.0"
  comment = "The function for web front"
}
