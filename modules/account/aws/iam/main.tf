terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.70.0"
    }
  }
}

locals {
  common_roles = {
    "administrator": {
      "managed_policy_arns": ["arn:aws:iam::aws:policy/AdministratorAccess"]
    }
    "read-only": {
      "managed_policy_arns": ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
    }
    "view-only": {
      "managed_policy_arns": ["arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"],
    }
  }
}

resource "aws_iam_role" "common" {
  provider = aws

  for_each = local.common_roles

  name        = each.key
  description = "common ${each.key} role"

  tags = {}

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  managed_policy_arns = lookup(each.value, "managed_policy_arns", [])
}

data "aws_iam_policy_document" "assume_role_policy" {
  provider = aws

  statement {
    actions = ["sts:AssumeRole", "sts:TagSession"]
    principals {
      type = "AWS"
      identifiers = formatlist("arn:aws:iam::%s:root", compact(var.trusted_account_ids))
    }
  }
}
