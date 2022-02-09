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
    opa_data = {
        "allowlist_deleted_addresses": [
            'google_project_iam_member.branch["VJftw/remote-ws:main:vjp-remote-ws:roles/iam.securityAdmin"]',
        ],
    },
)
