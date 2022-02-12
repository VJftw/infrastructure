subinclude("//build/defs:terraform")

terraform_root(
    name = "terraform-state",
    srcs = [
        "main.tf",
        "variables.tf",
    ],
    modules = [
        "//modules/terraform-remote-state/gcp:gcp",
    ],
    var_files = [
        "//accounts/gcp:vjp-sandbox-terraform-state_tfvars",
    ],
)
