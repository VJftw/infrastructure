subinclude("//build/defs:terraform")

terraform_root(
    name = "gcp",
    srcs = [
        "main.tf",
        "main_branch.tf",
        "oidc.tf",
        "pull_requests.tf",
        "repositories.tf",
        "services.tf",
    ],
    modules = [
        "//modules/account/gcp:gcp",
    ],
)
