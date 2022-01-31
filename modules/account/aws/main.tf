terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.70.0"
      configuration_aliases = [ 
        aws.management, 
      ]
    }
  }
}


locals {
  email_name = split("@", var.base_email)[0]
  email_domain = split("@", var.base_email)[1]
}

resource "aws_organizations_account" "account" {
  provider = aws.management

  name  = var.name

  email = "${local.email_name}+${var.name}@${local.email_domain}"

  iam_user_access_to_billing = "ALLOW"

  parent_id = length(local.organization_unit_ids) == 1 ? local.organization_unit_ids[0] : data.aws_organizations_organization.org.roots[0].id

  role_name = "OrganizationAccountAccessRole"

  tags = {}
}

data "aws_organizations_organization" "org" {
  provider = aws.management
}

data "aws_organizations_organizational_units" "ou" {
  provider = aws.management

  parent_id = data.aws_organizations_organization.org.roots[0].id
}

locals {
  organization_unit_ids = [for ou in data.aws_organizations_organizational_units.ou.children: ou.id if ou.name == var.organizational_unit_name]
}
