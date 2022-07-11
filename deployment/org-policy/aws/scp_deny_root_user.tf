/*
Policy: Deny Root User
Summary: AWS Control Tower recommends denying the usage of the AWS Root User.
         https://docs.aws.amazon.com/controltower/latest/userguide/strongly-recommended-guardrails.html#disallow-root-auser-actions

Credits:
  - The base deny root user policy has been translated to Terraform from:
    https://summitroute.com/blog/2020/03/25/aws_scp_best_practices/#require-the-use-of-imdsv2.

*/

locals {
  deny_root_user_exempt_accounts = []
  deny_root_user_exempt_ous      = []
}

data "aws_iam_policy_document" "deny_root_user" {
  statement {
    sid       = "DenyRootUser"
    effect    = "Deny"
    actions   = ["*"]
    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "aws:PrincipalArn"
      values   = ["arn:aws:iam::*:root"]
    }

    // Support exempting Accounts
    condition {
      test     = "StringNotEquals"
      variable = "aws:PrincipalAccount"

      values = [
        for account_name in local.deny_root_user_exempt_accounts :
        local.accounts_by_name[account_name].id
      ]
    }

    // Support exempting OUs
    condition {
      test     = "ForAnyValue:StringNotEquals"
      variable = "aws:PrincipalOrgPaths"

      values = [
        for ou_name in local.deny_root_user_exempt_ous :
        #"o-a1b2c3d4e5/r-ab12/ou-ab12-11111111/ou-ab12-22222222/"
        "${local.org_id}/${local.org_root.id}/${local.ous_by_name[ou_name].id}/"
      ]
    }
  }
}
