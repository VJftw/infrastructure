module "dns_aws_auth" {
  source = "//modules/auth/aws:aws"

  providers = {
    aws.management = aws
  }

  account_name           = "vjp-dns"
  pull_request_role_name = "read-only"

  branch_role_names = {
    "main" = "administrator"
  }

  role_name = "administrator"
}

provider "aws" {
  alias = "dns"

  assume_role {
    role_arn = module.dns_aws_auth.role_arn
  }

  region = "eu-west-1"
}

resource "aws_route53_zone" "aws" {
  provider = aws.dns

  name = "aws.${aws_route53_zone.root.name}"

  comment = ""

  tags = {}
}
