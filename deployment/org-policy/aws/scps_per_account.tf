/*
This Terraform configuration defines the SCPs to be applied on a per account
basis. At most 5 SCPs can be attached to a single account at once.

In order to work around this, we merge our desired policies to incorporate an
SCP with a meaningful name.
*/


locals {
  scps_per_account = {}


  __scps_per_account_iterator = { for account_scp in flatten([
    for account_name, scps in local.scps_per_account : [
      for scp in scps :
      {
        account_name = account_name
        scp_name     = scp.name
        policies     = scp.policies
      }
    ]
    ]) :
    "${account_scp.account_name}:${account_scp.scp_name}" => account_scp
  }

}

data "aws_iam_policy_document" "scps_per_account" {
  for_each = local.__scps_per_account_iterator

  source_policy_documents = each.value.policies[*].json
}

resource "aws_organizations_policy" "scps_per_account" {
  for_each = local.__scps_per_account_iterator

  name = "${each.value.account_name}-${each.value.scp_name}"

  content = data.aws_iam_policy_document.scps_per_account[each.key].json
}

resource "aws_organizations_policy_attachment" "scps_per_account" {
  for_each = local.__scps_per_account_iterator

  policy_id = aws_organizations_policy.scps_per_account[each.key].id
  target_id = local.accounts_by_name[each.value.account_name].id
}
