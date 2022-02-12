subinclude("//build/defs:terraform")

terraform_module(
    name = "aws",
    srcs = [
        "main.tf",
        "outputs.tf",
        "variables.tf",
    ],
    visibility = ["//deployment/accounts/aws:all"],  # Manage all AWS accounts in a single root module.
)
