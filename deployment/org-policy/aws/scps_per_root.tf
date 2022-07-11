/*
This Terraform configuration defines the SCPs to be applied on a per root
basis. At most 5 SCPs can be attached to a single root at once.

In order to work around this, we merge our desired policies to incorporate an
SCP with a meaningful name.
*/


locals {
  scps_per_root = {
    "Root" = [
      {
        name = "global"
        policies = [
          data.aws_iam_policy_document.require_imdsv2,
          data.aws_iam_policy_document.denied_services,
        ]
      }
    ]
  }


  __scps_per_root_iterator = { for root_scp in flatten([
    for root_name, scps in local.scps_per_root : [
      for scp in scps :
      {
        root_name = root_name
        scp_name  = scp.name
        policies  = scp.policies
      }
    ]
    ]) :
    "${root_scp.root_name}:${root_scp.scp_name}" => root_scp
  }

}

data "aws_iam_policy_document" "scps_per_root" {
  for_each = local.__scps_per_root_iterator

  source_policy_documents = each.value.policies[*].json
}

resource "aws_organizations_policy" "scps_per_root" {
  for_each = local.__scps_per_root_iterator

  name = "${each.value.root_name}-${each.value.scp_name}"

  content = data.aws_iam_policy_document.scps_per_root[each.key].json
}

resource "aws_organizations_policy_attachment" "scps_per_root" {
  for_each = local.__scps_per_root_iterator

  policy_id = aws_organizations_policy.scps_per_root[each.key].id
  target_id = local.roots_by_name[each.value.root_name].id
}
