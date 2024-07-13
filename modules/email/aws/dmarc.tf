// DMARC via SPF
resource "aws_route53_record" "dmarc" {
  zone_id = var.zone_id

  name = "_dmarc.${var.domain}"
  type = "TXT"
  ttl  = "300"

  records = [
    "v=DMARC1; p=quarantine; rua=mailto:dmarc@${var.domain}"
  ]
}

// DMARC via DKIM
resource "aws_ses_domain_dkim" "this" {
  domain = aws_ses_domain_identity.this.domain
}

resource "aws_route53_record" "dkim_record" {
  count   = 3

  zone_id = var.zone_id
  name    = "${aws_ses_domain_dkim.this.dkim_tokens[count.index]}._domainkey"
  type    = "CNAME"
  ttl     = "600"
  records = ["${aws_ses_domain_dkim.this.dkim_tokens[count.index]}.dkim.amazonses.com"]
}
