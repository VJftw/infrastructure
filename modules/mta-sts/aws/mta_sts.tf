resource "aws_route53_record" "mta_sts" {
  zone_id = data.aws_route53_zone.this.zone_id

  name = "_mta-sts.${var.domain}"
  type = "TXT"
  ttl  = "300"

  records = [
    "v=STSv1;id=${var.mta_sts_id};",
  ]
}
