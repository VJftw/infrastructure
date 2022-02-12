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
