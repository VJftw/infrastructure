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
