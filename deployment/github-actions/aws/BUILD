subinclude("//build/defs:terraform")

terraform_root(
    name = "aws",
    srcs = [
        "branches.tf",
        "main.tf",
        "oidc.tf",
        "pull-requests.tf",
        "repositories.yaml",
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
