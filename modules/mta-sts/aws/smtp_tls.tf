resource "aws_route53_record" "smtp_tls" {
  zone_id = data.aws_route53_zone.this.zone_id

  name = "_smtp._tls.${var.domain}"
  type = "TXT"
  ttl  = "300"

  records = [
    "v=TLSRPTv1;rua=mailto:${var.tls_report_email_address};",
  ]
}
