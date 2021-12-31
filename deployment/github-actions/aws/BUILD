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
    modules = [
        "//modules/account/aws:aws",
        "//modules/auth/aws:aws",
    ],
)
