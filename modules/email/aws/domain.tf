resource "aws_ses_domain_identity" "this" {
  domain = var.domain
}

resource "aws_ses_domain_identity_verification" "this" {
  domain = aws_ses_domain_identity.this.id

  depends_on = [aws_route53_record.verification_record]
}

resource "aws_route53_record" "verification_record" {
  zone_id = var.zone_id
  name    = "_amazonses.${aws_ses_domain_identity.this.id}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.this.verification_token]
}
