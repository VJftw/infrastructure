subinclude("//build/defs:terraform")

terraform_root(
    name = "aws",
    srcs = [
        "environments.tf",
        "main.tf",
        "organization.tf",
    ],
    modules = [
        "//modules/account/aws:aws",
    ],
)
