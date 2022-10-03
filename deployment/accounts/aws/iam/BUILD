subinclude("//build/defs:terraform")

terraform_per_account(
    srcs = [
        "iam.tf",
        "main.tf",
        "variables.tf",
    ],
    labels = ["iam"],
    per_account_roles = {
        "branches": {
            "main": "OrganizationAccountAccessRole",
        },
        "pull_request": "reader",
    },
    provider = "aws",
)

# re-import
"""
plz query alltargets --include terraform_root //deployment/accounts/aws/iam/... \
    | while read target ; do \
        echo "$target" \
        && export name="$(echo "$target" | cut -f2 -d:)" \
        && plz run "$target" -- "$(cat <<'EOF'
terraform init;
set +e;
terraform import aws_iam_role.common[\"administrator\"] administrator;
terraform import aws_iam_role.common[\"reader\"] reader;
terraform import aws_iam_role.common[\"viewer\"] viewer;
set -e;
EOF
)" \
    ; done
"""
