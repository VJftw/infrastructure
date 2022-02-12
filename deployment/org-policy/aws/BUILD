subinclude("//build/defs:terraform")

terraform_root(
    name = "aws",
    srcs = [
        "environments.tf",
        "main.tf",
        "organization.tf",
    ],
    account_auths = {
        "//accounts/aws:vjp-management_auth": {
            "branches": {
                "main": "administrator",
            },
            "pull_request": "reader",
        },
    },
)
