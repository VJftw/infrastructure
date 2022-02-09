package vjp.terraform

import data.vjp.common

import data.terraform
import input as tfplan

#########################################################################################
# Design
#----------------------------------------------------------------------------------------
# * Allow creations (with room to allowlist creations with secure settings).
# * Allow modifications (with room to denylist modifications away from secure settings).
# * Allowlist only for destructions.
#########################################################################################

# 
# Policy

deny[msg] {
	# deny when deleted resource address is not in allowlist.
	deleted_addresses := {address |
		resource := resources_per_action("delete")[_]
		address := resource.address
	}

	some address
	deleted_addresses[address]

	not common.contains(data.terraform.allowlist_deleted_addresses, address)

	msg := sprintf("'%s' is planned for deletion but not in the allowlist", [address])
}

# Maintaining an allowlist across multiple repos is unnecessary.
# This is more suitable for a monorepo/org which needs third party review on every type of resource.
# It is more appropriate for my usecase to ensure secure configuration of resources.
# deny[msg] {
# 	# deny when created resource type is not in allowlist.
#
# 	created_resource := resources_per_action("create")[_]
#
# 	not contains(data.terraform.allowlist_created_types, created_resource.type)
#
# 	msg := sprintf("'%s' is planned for creation but '%s' is not in the allowlist", [created_resource.address, created_resource.type])
# }

# utils

resources_per_action(action) = resources {
	resources := [resource |
		resource := tfplan.resource_changes[_]

		# conditions
		resource.change.actions[_] == action
	]
}
