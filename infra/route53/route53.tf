# 既に定義済みのリソースをimportして管理しているため `make plan` を実行すると差分が出ます。
resource "aws_route53_zone" "web_front" {
  name    = var.domain
  comment = "react vite sample 検証で利用"
  tags    = { Name = "${local.fqn}-route53-zone" }
}
