/*
Policy: Denied Services
Summary: AWS provide a control to deny the use of arbitrary AWS Services. We
         have to use a Deny directive as AWS attach an AWSFullAccess SCP which
         allows all AWS services by default. This is managed by AWS.
*/

locals {
  denied_services_exempt_ous = []

  denied_services_exempt_accounts = []
}

data "aws_iam_policy_document" "denied_services" {
  statement {
    sid    = "DeniedServices"
    effect = "Deny"
    actions = [
      "redshift:*",
    ]
    resources = ["*"]

    // Support exempting Accounts
    condition {
      test     = "StringNotEquals"
      variable = "aws:PrincipalAccount"

      values = [
        for account_name in local.denied_services_exempt_accounts :
        local.accounts_by_name[account_name].id
      ]
    }

    // Support exempting OUs
    condition {
      test     = "ForAnyValue:StringNotEquals"
      variable = "aws:PrincipalOrgPaths"

      values = [
        for ou_name in local.denied_services_exempt_ous :
        #"o-a1b2c3d4e5/r-ab12/ou-ab12-11111111/ou-ab12-22222222/"
        "${local.org_id}/${local.org_root.id}/${local.ous_by_name[ou_name].id}/"
      ]
    }
  }
}
