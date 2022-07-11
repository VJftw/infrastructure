/*
Policy: Deny Leave Organization
Summary: Leaving the organization is a way for Accounts to release themselves
         from an organization's SCP guardrails.

Credits:
  - The base deny leave organization policy has been translated to Terraform from:
    https://summitroute.com/blog/2020/03/25/aws_scp_best_practices/#require-the-use-of-imdsv2.

*/

locals {
  deny_leave_organization_exempt_accounts = []
  deny_leave_organization_exempt_ous      = []
}

data "aws_iam_policy_document" "deny_leave_organization" {
  statement {
    sid       = "DenyLeaveOrganization"
    effect    = "Deny"
    actions   = ["organizations:LeaveOrganization"]
    resources = ["*"]

    // Support exempting Accounts
    condition {
      test     = "StringNotEquals"
      variable = "aws:PrincipalAccount"

      values = [
        for account_name in local.deny_leave_organization_exempt_accounts :
        local.accounts_by_name[account_name].id
      ]
    }

    // Support exempting OUs
    condition {
      test     = "ForAnyValue:StringNotEquals"
      variable = "aws:PrincipalOrgPaths"

      values = [
        for ou_name in local.deny_leave_organization_exempt_ous :
        #"o-a1b2c3d4e5/r-ab12/ou-ab12-11111111/ou-ab12-22222222/"
        "${local.org_id}/${local.org_root.id}/${local.ous_by_name[ou_name].id}/"
      ]
    }
  }
}
