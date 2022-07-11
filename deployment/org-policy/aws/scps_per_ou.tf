/*
This Terraform configuration defines the SCPs to be applied on a per
Organisation Unit basis. At most 5 SCPs can be attached to a single OU at
once.

In order to work around this, we merge our desired policies to incorporate an
SCP with a meaningful name.
*/


locals {
  scps_per_ou = {}


  __scps_per_ou_iterator = { for ou_scp in flatten([
    for ou_name, scps in local.scps_per_ou : [
      for scp in scps :
      {
        ou_name  = ou_name
        scp_name = scp.name
        policies = scp.policies
      }
    ]
    ]) :
    "${ou_scp.ou_name}:${ou_scp.scp_name}" => ou_scp
  }

}

data "aws_iam_policy_document" "scps_per_ou" {
  for_each = local.__scps_per_ou_iterator

  source_policy_documents = each.value.policies[*].json
}

resource "aws_organizations_policy" "scps_per_ou" {
  for_each = local.__scps_per_ou_iterator

  name = "${each.value.ou_name}-${each.value.scp_name}"

  content = data.aws_iam_policy_document.scps_per_ou[each.key].json
}

resource "aws_organizations_policy_attachment" "scps_per_ou" {
  for_each = local.__scps_per_ou_iterator

  policy_id = aws_organizations_policy.scps_per_ou[each.key].id
  target_id = local.ous_by_name[each.value.ou_name].id
}
