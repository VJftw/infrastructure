// TODO: move homomorphic-encryption to new vjp org.
resource "aws_route53_record" "homomorphic_encryption" {
  provider = aws.management

  name = "homomorphic-encryption.vjpatel.me."
  type = "CNAME"
  zone_id = aws_route53_zone.root.zone_id
  ttl  = "300"

  records = ["d178tz16j2yb9a.cloudfront.net"]
}

resource "aws_route53_record" "homomorphic_encryption_acm" {
  provider = aws.management

  name    = "_74ad61066a64cd739b30b4d628b5f569.homomorphic-encryption.vjpatel.me."
  type    = "CNAME"
  zone_id = aws_route53_zone.root.zone_id
  ttl  = "300"

  records = ["_0cab05b73e3f57433641eb491568b89a.hkvuiqjoua.acm-validations.aws."]
}

resource "aws_route53_record" "api_homomorphic_encryption" {
  provider = aws.management

  name = "api.homomorphic-encryption.vjpatel.me."
  type = "CNAME"
  zone_id = aws_route53_zone.root.zone_id
  ttl  = "300"

  records = ["d1qlult3kv3te9.cloudfront.net"]
}


resource "aws_route53_record" "api_homomorphic_encryption_acm" {
  provider = aws.management

  name    = "_0883ba27d44d4588046b471286379eac.api.homomorphic-encryption.vjpatel.me."
  type    = "CNAME"
  zone_id = aws_route53_zone.root.zone_id
  ttl  = "300"

  records = ["_1973cd57039f7949e2fc5cf065d909ed.hkvuiqjoua.acm-validations.aws."]
}
