terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.70.0"
      configuration_aliases = [ aws.management, aws.account ]
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

resource "aws_iam_account_alias" "alias" {
  provider = aws.management

  account_alias = aws_organizations_account.account.name
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

  trusted_account_names = [
    "vjp-management",
  ]
}

module "iam" {
  source = "//modules/account/aws/iam:iam"

  providers = {
    aws = aws.account
  }

  trusted_account_ids = [
    for a in data.aws_organizations_organization.org.accounts: a.id if contains(local.trusted_account_names, a.name)
  ]
}
