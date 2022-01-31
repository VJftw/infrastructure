package terraform.analysis

import input as tfplan

#########################################################################################
# Design
#----------------------------------------------------------------------------------------
# * Allow creations (with room to allowlist creations with secure settings).
# * Allow modifications (with room to denylist modifications away from secure settings).
# * Allowlist only for destructions.
#########################################################################################

allowlist_deleted_addresses = {"aws_autoscaling_group.my_asg"} # TODO: this should be per terraform_root

allowlist_created_types = {
	"aws_iam_account_alias",
	"aws_iam_openid_connect_provider",
	"aws_iam_policy",
	"aws_iam_role",
	"aws_organizations_account",
	"aws_organizations_organization",
	"aws_organizations_organizational_unit",
	"aws_route53_record",
	"aws_route53_zone",
	"google_billing_account_iam_member",
	"google_billing_budget",
	"google_dns_managed_zone",
	"google_folder",
	"google_folder_iam_member",
	"google_iam_workload_identity_pool",
	"google_iam_workload_identity_pool_provider",
	"google_kms_crypto_key",
	"google_kms_crypto_key_iam_binding",
	"google_kms_key_ring",
	"google_organization_iam_member",
	"google_organization_policy",
	"google_project",
	"google_project_iam_member",
	"google_project_service",
	"google_service_account",
	"google_service_account_iam_member",
	"google_storage_bucket",
	"google_storage_bucket_iam_member",
}

# Policy

deny[msg] {
	# deny when deleted resource address is not in allowlist.
	deleted_addresses := {address |
		resource := resources_per_action("delete")[_]
		address := resource.address
	}

	some address
	deleted_addresses[address]

	not contains(allowlist_deleted_addresses, address)

	msg := sprintf("'%s' is planned for deletion but not in the allowlist", [address])
}

deny[msg] {
	# deny when created resource type is not in allowlist.

	created_resource := resources_per_action("create")[_]

	not contains(allowlist_created_types, created_resource.type)

	msg := sprintf("'%s' is planned for creation but '%s' is not in the allowlist", [created_resource.address, created_resource.type])
}

# utils

resources_per_action(action) = resources {
	resources := [resource |
		resource := tfplan.resource_changes[_]

		# conditions
		resource.change.actions[_] == action
	]
}

contains(haystack, needle) {
	haystack[_] = needle
}

contains_all(haystack, needles) {
	count(needles - haystack) == 0
}
