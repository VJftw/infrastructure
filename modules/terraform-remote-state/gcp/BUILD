subinclude("//build/defs:terraform")

terraform_module(
    name = "gcp",
    srcs = [
        "bucket.tf",
        "main.tf",
        "variables.tf",
    ],
    visibility = ["PUBLIC"],
    deps = [
        "//modules/kms/gcp",
    ],
)
