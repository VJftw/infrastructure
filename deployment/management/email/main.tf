provider "aws" {
  profile = "vjp-dns"
  region  = "eu-west-1"
}

data "aws_route53_zone" "test" {
  name         = "aws.vjpatel.me"
  private_zone = false
}


module "email" {
  source = "//modules/email/aws:aws"

  providers = {
    aws = aws
  }

  domain = data.aws_route53_zone.test.name
  zone_id = data.aws_route53_zone.test.zone_id
  forwarding_email_recipient = "meetthevj@gmail.com"
}
