subinclude("//build/defs:terraform")

terraform_per_account(
    srcs = [
        "iam.tf",
        "main.tf",
        "variables.tf",
    ],
    modules = [
        "//modules/auth/aws:aws",
    ],
    provider = "aws",
)
