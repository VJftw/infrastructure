resource "aws_organizations_organization" "org" {
  provider = aws.management

  aws_service_access_principals = []

  feature_set = "ALL"
}

module "account" {
  source = "//modules/account/aws:aws"

  base_email = "aws@vjpatel.me"
  name       = "vjp-management"

  organizational_unit_name = "management"

  providers = {
    aws.management = aws.management
  }
}


// organizational roles

locals {
  trusted_account_names = [
    "vjp-management",
  ]

  organizational_roles = {
    "account-creator" : {
      "managed_policy_arns" : ["arn:aws:iam::aws:policy/AWSOrganizationsFullAccess"]
    }
  }
}

resource "aws_iam_role" "organizational" {
  provider = aws.management

  for_each = local.organizational_roles

  name        = each.key
  description = "organizational ${each.key} role"

  tags = {}

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  managed_policy_arns = lookup(each.value, "managed_policy_arns", [])
}

data "aws_iam_policy_document" "assume_role_policy" {
  provider = aws.management

  statement {
    actions = ["sts:AssumeRole", "sts:TagSession"]
    principals {
      type        = "AWS"
      identifiers = formatlist("arn:aws:iam::%s:root", [for a in aws_organizations_organization.org.accounts : a.id if contains(local.trusted_account_names, a.name)])
    }
  }
}
