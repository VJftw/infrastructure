resource "aws_route53_record" "mx" {
  zone_id = var.zone_id

  name = var.domain
  type = "MX"
  ttl  = "300"

  records = [
    "10 inbound-smtp.${data.aws_region.current.name}.amazonaws.com",
  ]
}
