output "web_front" {
  value = {
    id   = aws_route53_zone.web_front.id,
    name = aws_route53_zone.web_front.name
  }
}
