subinclude("//build/defs:terraform")

terraform_root(
    name = "terraform-state",
    srcs = [
        "bucket.tf",
        "main.tf",
    ],
    modules = [
        "//modules/account/gcp:gcp",
    ],
)
