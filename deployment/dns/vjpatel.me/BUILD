subinclude("//build/defs:terraform")

terraform_root(
    name = "vjpatel.me",
    srcs = [
        "aws.tf",
        "gcp.tf",
        "gsuite.tf",
        "main.tf",
        "root.tf",
    ],
    account_auths = {
      "//accounts/aws:vjp-dns_auth": {
        "branches": {
          "main": "administrator",
        },
        "pull_request": "reader",
      },
    },
)
