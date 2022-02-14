locals {
  common_roles = {
    "administrator" : {
      "managed_policy_arns" : ["arn:aws:iam::aws:policy/AdministratorAccess"]
    }
    "reader" : {
      "managed_policy_arns" : ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
    }
    "viewer" : {
      "managed_policy_arns" : ["arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"],
    }
  }
}

resource "aws_iam_role" "common" {
  provider = aws.account

  for_each = local.common_roles

  name        = each.key
  description = "common ${each.key} role"

  tags = {}

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  managed_policy_arns = lookup(each.value, "managed_policy_arns", [])
}

data "aws_iam_policy_document" "assume_role_policy" {
  provider = aws.account

  statement {
    sid = "AllowTrustedIAMUsers"

    actions = ["sts:AssumeRole", "sts:TagSession"]
    principals {
      type = "AWS"
      # Allow the given IAM users from the given accounts.
      identifiers = compact(flatten([
        for account_name, iam_users in local.trusted_account_iam_users :
        formatlist("arn:aws:iam::%s:user/%s", local.account_names_to_ids[account_name], iam_users)
        if contains(keys(local.account_names_to_ids), account_name)
      ]))
    }

    # Ensure that the IAM user assigns their own Username as the role session name for audit logging.
    condition {
      test     = "StringEquals"
      variable = "sts:RoleSessionName"
      values   = ["$${aws:username}"]
    }
  }

  statement {
    sid = "AllowOIDCProviders"

    actions = ["sts:AssumeRole", "sts:TagSession"]
    principals {
      type = "AWS"
      # Broader access which is restricted by IAM condition (below): allow any principal in defined accounts.
      identifiers = formatlist("arn:aws:iam::%s:root", compact([
        for account_name, providers in local.trusted_account_oidc_providers : lookup(local.account_names_to_ids, account_name, "")
      ]))
    }

    condition {
      # Only allow principals with the given `aws:FederatedProvider` values.
      # This is set when AssumeRoleWithWebIdentity is used (OIDC).
      # https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_condition-keys.html#condition-keys-federatedprovider
      test     = "StringEquals"
      variable = "aws:FederatedProvider"
      values = compact(flatten([
        for account_name, providers in local.trusted_account_oidc_providers :
        formatlist("arn:aws:iam::%s:oidc-provider/%s", local.account_names_to_ids[account_name], providers)
        if contains(keys(local.account_names_to_ids), account_name)
      ]))
    }
  }
}
