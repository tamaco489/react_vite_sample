# 既に定義済みのリソースをimportして管理しているため `make plan` を実行すると差分が出ます。
resource "aws_route53_zone" "web_front" {
  name    = var.domain
  comment = "React/Vite SPA構成の検証で利用"
  tags    = { Name = "web-front-for-${local.fqn}" }
}

resource "aws_route53_record" "web_front" {
  zone_id = aws_route53_zone.web_front.zone_id
  name    = "www.${var.domain}"
  type    = "A"

  alias {
    name                   = data.terraform_remote_state.cloudfront.outputs.web_front.domain_name
    zone_id                = data.terraform_remote_state.cloudfront.outputs.web_front.hosted_zone_id
    evaluate_target_health = false
  }
}
