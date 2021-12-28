subinclude("//build/defs:terraform")

terraform_root(
    name = "terraform-state",
    srcs = [
        "main.tf",
    ],
    modules = [
        "//modules/account/gcp:gcp",
        "//modules/terraform-remote-state/gcp:gcp",
    ],
)
