subinclude("//build/defs:terraform")

terraform_root(
    name = "aws",
    srcs = [
        "main.tf",
    ],
    account_auths = {
        "//accounts/aws:vjp-management_auth": {
            "branches": {
                "main": "administrator",
            },
            "pull_request": "reader",
        },
    },
    modules = [
        "//modules/mta-sts/aws:aws",
    ],
)
