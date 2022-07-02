subinclude("//build/defs:terraform")

terraform_per_account(
    srcs = [
        "alias.tf",
        "main.tf",
        "variables.tf",
    ],
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
plz query alltargets --include terraform_workspace //deployment/accounts/aws/alias/... \
    | while read target ; do \
        echo "$target" \
        && export alias="$(echo "$target" | cut -f2 -d:)" \
        && plz run "$target" -- "terraform init && terraform import aws_iam_account_alias.alias $alias" \
    ; done
"""
