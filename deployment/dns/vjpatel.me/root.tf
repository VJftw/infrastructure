resource "aws_route53_zone" "root" {
  provider = aws.management

  name = "vjpatel.me"

  comment = ""

  tags = {}
}

resource "aws_route53_record" "aws" {
  provider = aws.management

  name    = "aws.${aws_route53_zone.root.name}"
  ttl     = 172800
  type    = "NS"
  zone_id = aws_route53_zone.root.zone_id

  records = aws_route53_zone.aws.name_servers
}

resource "aws_route53_record" "gcp" {
  provider = aws.management

  name    = "gcp.${aws_route53_zone.root.name}"
  ttl     = 172800
  type    = "NS"
  zone_id = aws_route53_zone.root.zone_id
  records = google_dns_managed_zone.gcp.name_servers
}

resource "aws_route53_record" "vjp_website" {
  // We can't create CNAMEs at the apex of a DNS zone, so we must use aliases.
  provider = aws.management

  for_each = toset(["A", "AAAA"])

  name    = aws_route53_zone.root.name
  type    = each.key
  zone_id = aws_route53_zone.root.zone_id

  alias {
    name                   = "d1mc7rhc6swrfe.cloudfront.net"
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = true
  }
}
