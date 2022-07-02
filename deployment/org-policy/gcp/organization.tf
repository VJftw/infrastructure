
locals {
  # see https://cloud.google.com/resource-manager/docs/organization-policy/org-policy-constraints
  organization_boolean_constraints = [

    # PREVIEW: Secure your Cloud Storage data from public exposure by enforcing public access prevention. This governance policy prevents existing and future resources from being accessed via the public internet by disabling and blocking ACLs and IAM permissions that grant access to allUsers and allAuthenticatedUsers. Enforce this policy on the entire organization (recommended), specific projects, or specific folders to ensure no data is publicly exposed.
    # This policy overrides existing public permissions. Public access will be revoked for existing buckets and objects after this policy is enabled.
    "constraints/storage.publicAccessPrevention",

    # This boolean constraint requires buckets to use uniform bucket-level access where this constraint is set to True. Any new bucket in the Organization resource must have uniform bucket-level access enabled, and no existing buckets in the organization resource can disable uniform bucket-level access.
    # Enforcement of this constraint is not retroactive: existing buckets with uniform bucket-level access disabled continue to have it disabled. The default value for this constraint is False.
    # Uniform bucket-level access disables the evaluation of ACLs assigned to Cloud Storage objects in the bucket. Consequently, only IAM policies grant access to objects in these buckets.
    "constraints/storage.uniformBucketLevelAccess",

    # This boolean constraint restricts configuring Public IP on Cloud SQL instances where this constraint is set to True. This constraint is not retroactive, Cloud SQL instances with existing Public IP access will still work even after this constraint is enforced.
    # By default, Public IP access is allowed to Cloud SQL instances.
    "constraints/sql.restrictPublicIp",

    # BETA: This boolean constraint, when set to True, requires all newly created, restarted, or updated Cloud SQL instances to use customer-managed encryption keys (CMEK). It is not retroactive (meaning existing instances with Google-managed encryption are not impacted unless they are updated or refreshed).
    # By default, this constraint is set to False and Google-managed encryption is allowed for Cloud SQL instances.
    "constraints/sql.disableDefaultEncryptionCreation",

    # This boolean constraint skips the creation of the default network and related resources during Google Cloud Platform Project resource creation where this constraint is set to True. By default, a default network and supporting resources are automatically created when creating a Project resource.
    "constraints/compute.skipDefaultNetworkCreation",

    # This list constraint defines the set of Compute Engine VM instances that are allowed to use external IP addresses.
    # By default, all VM instances are allowed to use external IP addresses.
    # "constraints/compute.vmExternalIpAccess"

    # 	This boolean constraint disables the feature that allows uploading public key to service account where this constraint is set to `True`.
    # By default, users can upload public key to service account based on their Cloud IAM roles and permissions.
    "constraints/iam.disableServiceAccountKeyUpload",

    # This boolean constraint, when enforced, prevents the default App Engine and Compute Engine service accounts that are created in your projects from being automatically granted any IAM role on the project when the accounts are created.
    # By default, these service accounts automatically receive the Editor role when they are created.
    "constraints/iam.automaticIamGrantsForDefaultServiceAccounts",
  ]
}

resource "google_organization_policy" "policy" {
  for_each = toset(local.organization_boolean_constraints)

  org_id     = data.google_organization.org.org_id
  constraint = each.key

  boolean_policy {
    enforced = true
  }
}
