subinclude("//build/defs:terraform")

terraform_per_account(
    srcs = [
        "bucket.tf",
        "main.tf",
        "sink.tf",
        "variables.tf",
    ],
    account_auths = {
        "//accounts/gcp:vjp-logs_auth": {
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
    provider = "gcp",
)
