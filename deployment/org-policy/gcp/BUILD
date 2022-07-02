subinclude("//build/defs:terraform")

terraform_root(
    name = "gcp",
    srcs = [
        "environments.tf",
        "main.tf",
        "organization.tf",
    ],
)

# re-import
"""
$ plz run //deployment/org-policy/gcp:gcp -- bash
terraform init

terraform import google_folder.environment[\"management\"] folders/24311430077
terraform import google_folder.environment[\"production\"] folders/37738865617
terraform import google_folder.environment[\"sandbox\"] folders/1044201836931

terraform import "google_organization_policy.policy[\"constraints/storage.publicAccessPrevention\"]" "645598249928/constraints/storage.publicAccessPrevention"
terraform import "google_organization_policy.policy[\"constraints/storage.uniformBucketLevelAccess\"]" "645598249928/constraints/storage.uniformBucketLevelAccess"
terraform import "google_organization_policy.policy[\"constraints/sql.restrictPublicIp\"]" "645598249928/constraints/sql.restrictPublicIp"
terraform import "google_organization_policy.policy[\"constraints/sql.disableDefaultEncryptionCreation\"]" "645598249928/constraints/sql.disableDefaultEncryptionCreation"
terraform import "google_organization_policy.policy[\"constraints/compute.skipDefaultNetworkCreation\"]" "645598249928/constraints/compute.skipDefaultNetworkCreation"
terraform import "google_organization_policy.policy[\"constraints/iam.disableServiceAccountKeyUpload\"]" "645598249928/constraints/iam.disableServiceAccountKeyUpload"
terraform import "google_organization_policy.policy[\"constraints/iam.automaticIamGrantsForDefaultServiceAccounts\"]" "645598249928/constraints/iam.automaticIamGrantsForDefaultServiceAccounts"
"""
