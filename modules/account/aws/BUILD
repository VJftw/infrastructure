subinclude("//build/defs:terraform")

terraform_module(
    name = "aws",
    srcs = [
        "main.tf",
        "outputs.tf",
        "variables.tf",
    ],
    visibility = ["PUBLIC"],
    deps = [
        "//modules/account/aws/iam",
    ],
)
