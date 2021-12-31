locals {
  environments = [
    "management",
    "production",
    "sandbox",
  ]
}

resource "aws_organizations_organizational_unit" "environment" {
  provider = aws.management

  for_each = toset(local.environments)

  name      = each.key
  parent_id = aws_organizations_organization.org.roots[0].id
}
