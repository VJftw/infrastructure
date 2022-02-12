resource "aws_route53_zone" "aws" {
  provider = aws.dns

  name = "aws.${aws_route53_zone.root.name}"

  comment = ""

  tags = {}
}
