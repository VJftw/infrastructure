/*
Policy: Require IMDSV2
Summary: AWS provide a defense-in-depth control to mitigate the impact of a
         workload vulnerable to SSRF-style attacks or open reverse proxies.
         This is done by enforcing the use of IMDSV2 which requires a session
         is established via a PUT request to obtain AWS API credentials from
         EC2 instance metadata.

Credits:
  - The base require IMDSV2 policy has been translated to Terraform from:
    https://summitroute.com/blog/2020/03/25/aws_scp_best_practices/#require-the-use-of-imdsv2.

*/

locals {
  require_imdsv2_exempt_accounts = []
  require_imdsv2_exempt_ous      = []
}

data "aws_iam_policy_document" "require_imdsv2" {
  statement {
    sid       = "RequireAllRolesToUseIMDSV2"
    effect    = "Deny"
    actions   = ["*"]
    resources = ["*"]

    condition {
      test     = "NumericLessThan"
      variable = "ec2:RoleDelivery"
      values   = ["2.0"]
    }

    // Support exempting Accounts
    condition {
      test     = "StringNotEquals"
      variable = "aws:PrincipalAccount"

      values = [
        for account_name in local.require_imdsv2_exempt_accounts :
        local.accounts_by_name[account_name].id
      ]
    }

    // Support exempting OUs
    condition {
      test     = "ForAnyValue:StringNotEquals"
      variable = "aws:PrincipalOrgPaths"

      values = [
        for ou_name in local.require_imdsv2_exempt_ous :
        #"o-a1b2c3d4e5/r-ab12/ou-ab12-11111111/ou-ab12-22222222/"
        "${local.org_id}/${local.org_root.id}/${local.ous_by_name[ou_name].id}/"
      ]
    }
  }

  statement {
    sid       = "RequireIMDSV2"
    effect    = "Deny"
    actions   = ["ec2:RunInstances"]
    resources = ["arn:aws:ec2:*:*:instance/*"]

    condition {
      test     = "StringNotEquals"
      variable = "ec2:MetadataHttpTokens"
      values   = ["required"]
    }

    // Support exempting Accounts
    condition {
      test     = "StringNotEquals"
      variable = "aws:PrincipalAccount"

      values = [
        for account_name in local.require_imdsv2_exempt_accounts :
        local.accounts_by_name[account_name].id
      ]
    }

    // Support exempting OUs
    condition {
      test     = "ForAnyValue:StringNotEquals"
      variable = "aws:PrincipalOrgPaths"

      values = [
        for ou_name in local.require_imdsv2_exempt_ous :
        #"o-a1b2c3d4e5/r-ab12/ou-ab12-11111111/ou-ab12-22222222/"
        "${local.org_id}/${local.org_root.id}/${local.ous_by_name[ou_name].id}/"
      ]
    }
  }

  statement {
    sid       = "DenyModificationsToInstanceMetadataOptions"
    effect    = "Deny"
    actions   = ["ec2:ModifyInstanceMetadataOptions"]
    resources = ["*"]

    // Support exempting Accounts
    condition {
      test     = "StringNotEquals"
      variable = "aws:PrincipalAccount"

      values = [
        for account_name in local.require_imdsv2_exempt_accounts :
        local.accounts_by_name[account_name].id
      ]
    }

    // Support exempting OUs
    condition {
      test     = "ForAnyValue:StringNotEquals"
      variable = "aws:PrincipalOrgPaths"

      values = [
        for ou_name in local.require_imdsv2_exempt_ous :
        #"o-a1b2c3d4e5/r-ab12/ou-ab12-11111111/ou-ab12-22222222/"
        "${local.org_id}/${local.org_root.id}/${local.ous_by_name[ou_name].id}/"
      ]
    }
  }
}
