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

/*
Manually create: aws+management@vjpatel.me

TF:
Rely on password reset feature for these
* aws+github-actions@vjpatel.me
* aws+logs@vjpatel.me
* aws+dns@vjpatel.me
* aws+website@vjpatel.me

Problems: 
  Enumerate Account IDs in organization
    - maybe: data "aws_organizations_organization" "example" {}
  Map names to Account IDs
    - maybe: data "aws_organizations_organization" "example" {}
  Enumerate OUs in organization
    - maybe: data "aws_organizations_organizational_units" "ou" {}
  Map names to OUs
    - maybe: data "aws_organizations_organizational_units" "ou" {}
*/
