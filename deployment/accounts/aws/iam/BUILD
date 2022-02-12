subinclude("//build/defs:terraform")

terraform_per_account(
    srcs = [
        "iam.tf",
        "main.tf",
        "variables.tf",
    ],
    provider = "aws",
    per_account_roles = {
        "branches": {
            "main": "administrator",
        },
        "pull_request": "reader",
    },
)
