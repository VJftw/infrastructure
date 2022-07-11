locals {
  environments = jsondecode(file("${path.module}/environments.json"))
}

resource "aws_organizations_organizational_unit" "environment" {
  provider = aws.management

  for_each = local.environments

  name      = each.key
  parent_id = aws_organizations_organization.org.roots[0].id
}
