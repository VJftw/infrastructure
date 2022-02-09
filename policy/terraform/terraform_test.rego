package vjp.terraform

import data.vjp.common

test_deny_unapproved_delete {
	deny["'unapproved_resource.web' is planned for deletion but not in the allowlist"] with input as {"resource_changes": [{
		"address": "unapproved_resource.web",
		"change": {"actions": ["delete"]},
	}]}
		 with data.terraform as {"allowlist_deleted_addresses": []}
}

test_allow_approved_delete {
	common.is_empty(deny) with input as {"resource_changes": [{
		"address": "aws_autoscaling_group.my_asg",
		"change": {"actions": ["delete"]},
	}]}
		 with data.terraform as {"allowlist_deleted_addresses": ["aws_autoscaling_group.my_asg"]}
}

# test_deny_create_when_missing_from_allowlist {
# 	deny["'unapproved_resource.web' is planned for creation but 'unapproved_resource' is not in the allowlist"] with input as {"resource_changes": [{
# 		"address": "unapproved_resource.web",
# 		"type": "unapproved_resource",
# 		"change": {"actions": ["create"]},
# 	}]} with data.terraform as {"allowlist_created_types": []}
# }
# test_allow_create_when_in_allowlist {
# 	common.is_empty(deny) with input as {"resource_changes": [{
# 		"address": "aws_iam_account_alias.web",
# 		"type": "aws_iam_account_alias",
# 		"change": {"actions": ["create"]},
# 	}]} with data.terraform as {"allowlist_created_types": ["aws_iam_account_alias"]}
# }
