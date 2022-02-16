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
