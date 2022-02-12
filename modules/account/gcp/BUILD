subinclude("//build/defs:terraform")

terraform_module(
    name = "gcp",
    srcs = [
        "main.tf",
        "outputs.tf",
        "variables.tf",
    ],
    visibility = ["//deployment/accounts/gcp:all"], # Manage all GCP projects in a single root module.
)
