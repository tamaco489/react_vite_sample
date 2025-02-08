# CloudFront用のSSL/TLS証明書を AWS Certificate Manager (ACM) で発行する。
# ACM証明書を発行し、Route53のDNS検証を使用して所有権を確認する設定。
resource "aws_acm_certificate" "cloudfront" {
  domain_name               = "*.${data.terraform_remote_state.route53.outputs.web_front.name}"
  subject_alternative_names = [data.terraform_remote_state.route53.outputs.web_front.name]

  # 証明書の検証方法をDNS検証として設定
  # AWSは、指定したドメインの所有権を確認するために DNSレコードをRoute53に作成することを求める。
  validation_method = "DNS"

  # 新しい証明書を発行する際に、古い証明書を削除する前に新しい証明書を作成する。
  # CloudFrontは証明書の切り替えに時間がかかるため、証明書が一時的に無効になるのを防ぐ。
  lifecycle {
    create_before_destroy = true
  }

  provider = aws.cloudfront

  tags = {
    Name = "${local.fqn}-cloudfront-acm"
  }
}
