subinclude("//build/defs:terraform")

terraform_per_account(
    srcs = [
        "alias.tf",
        "main.tf",
        "variables.tf",
    ],
    modules = [
        "//modules/auth/aws:aws",
    ],
    provider = "aws",
)
