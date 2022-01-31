resource "aws_route53_record" "mx" {
  provider = aws.management

  zone_id = aws_route53_zone.root.zone_id

  name = "vjpatel.me"
  type = "MX"
  ttl  = "300"

  records = [
    "1 aspmx.l.google.com",
    "5 alt1.aspmx.l.google.com",
    "5 alt2.aspmx.l.google.com",
    "10 alt3.aspmx.l.google.com",
    "10 alt4.aspmx.l.google.com",
  ]
}

resource "aws_route53_record" "txt" {
  provider = aws.management

  zone_id = aws_route53_zone.root.zone_id

  name = "vjpatel.me"
  type = "TXT"
  ttl  = "300"

  records = [
    # Google Sites Verification
    "google-site-verification=xSiQkpqUhTHaSyIC8SaudyiTz3dvPEPFHpRSonLnbpw",
    # SPF record
    "v=spf1 include:_spf.google.com ~all",
  ]
}

resource "aws_route53_record" "dmarc" {
  provider = aws.management

  zone_id = aws_route53_zone.root.zone_id

  name = "_dmarc.vjpatel.me"
  type = "TXT"
  ttl  = "300"

  records = [
    "v=DMARC1; p=quarantine; rua=mailto:dmarc@vjpatel.me"
  ]
}

resource "aws_route53_record" "gsuite_domain_key" {
  provider = aws.management

  zone_id = aws_route53_zone.root.zone_id

  name = "google._domainkey.vjpatel.me"
  type = "TXT"
  ttl  = "300"

  records = [
    "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDBDwKTs7+hMsHSFHhYiiSNglZDT6ZdJF2A9KEm47hnJzL1g61PHthasi5GW33gSpi/QuZs2hiyVd7HIxixNQWwofH3gY1OLsN11pbZEzqDTZcFy4THXNSHHGlgHIVZcz3mX+fTBqi4KEBNa/+cAVjRWXXBSnz5/d5jqimnbDwoQwIDAQAB"
  ]
}

resource "aws_route53_record" "gsuite_service" {
  provider = aws.management

  for_each = toset([
    "drive",
    "calendar",
    "mail",
  ])

  zone_id = aws_route53_zone.root.zone_id

  name = "${each.key}.vjpatel.me"
  type = "CNAME"
  ttl  = "300"

  records = ["ghs.googlehosted.com"]
}
