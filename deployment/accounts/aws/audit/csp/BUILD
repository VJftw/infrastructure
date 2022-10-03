subinclude("//build/defs:terraform")

terraform_per_account(
    srcs = [
        "bucket.tf",
        "cloudtrail.tf",
        "main.tf",
        "variables.tf",
    ],
    account_auths = {
        "//accounts/aws:vjp-logs_auth": {
            "branches": {
                "main": "administrator",
            },
            "pull_request": "reader",
        },
    },
    per_account_roles = {
        "branches": {
            "main": "administrator",
        },
        "pull_request": "reader",
    },
    provider = "aws",
)

# re-import
"""
plz query alltargets --include terraform_root //deployment/accounts/aws/audit/csp/... \
    | while read target ; do \
        echo "$target" \
        && export name="$(echo "$target" | cut -f2 -d:)" \
        && plz run "$target" -- "$(cat <<'EOF'
terraform init;
set +e;
terraform import aws_s3_bucket.audit_csp "${name}-audit-csp";
terraform import aws_s3_bucket_acl.audit_csp "${name}-audit-csp";
terraform import aws_s3_bucket_object_lock_configuration.audit_csp "${name}-audit-csp";
terraform import aws_kms_key.bucket "$(AWS_PROFILE="vjp-logs" AWS_REGION="us-east-1" aws kms list-aliases --output=text  | grep "$name" | awk '{ print $6 }')";
terraform import aws_s3_bucket_server_side_encryption_configuration.audit_csp "${name}-audit-csp";
terraform import aws_s3_bucket_lifecycle_configuration.audit_csp "${name}-audit-csp";
terraform import aws_s3_bucket_policy.audit_csp "${name}-audit-csp";
terraform import aws_s3_bucket_public_access_block.audit_csp "${name}-audit-csp";
terraform import aws_cloudtrail.audit_csp audit-csp;
terraform import aws_kms_key.cloudtrail "$(AWS_PROFILE="${name}" AWS_REGION="us-east-1" aws kms list-aliases --output=text  | grep cloudtrail-audit-csp | awk '{ print $6 }')";
terraform import aws_kms_alias.cloudtrail "alias/cloudtrail-audit-csp";
set -e;
EOF
)" \
    ; done
"""
