subinclude("//build/defs:terraform")

terraform_root(
    name = "gcp",
    srcs = [
        "branches.tf",
        "main.tf",
        "oidc.tf",
        "pull-requests.tf",
        "repositories.yaml",
        "services.tf",
        "variables.tf",
    ],
    modules = [
        "//modules/account/gcp:gcp",
    ],
    var_files = [
        "//accounts/gcp:vjp-github-actions_tfvars",
    ],
)
