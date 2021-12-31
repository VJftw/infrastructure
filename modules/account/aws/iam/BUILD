subinclude("//build/defs:terraform")

terraform_module(
    name = "iam",
    srcs = [
        "main.tf",
        "variables.tf",
    ],
    visibility = ["//modules/account/aws/..."],
)
