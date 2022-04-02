subinclude("//build/defs:terraform")

terraform_per_account(
    srcs = [
        "bucket.tf",
        "cleanup-kms-key-versions.tf",
        "cleanup-kms-key-versions/main.py",
        "cleanup-kms-key-versions/requirements.txt",
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
