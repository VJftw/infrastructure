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
    opa_data = {
        "allowlist_deleted_addresses": [
            'google_project_iam_member.branch["VJftw/remote-ws:main:vjp-remote-ws:roles/compute.admin"]',
            'google_project_iam_member.branch["VJftw/remote-ws:main:vjp-remote-ws:roles/iam.serviceAccountAdmin"]',
            'google_project_iam_member.branch["VJftw/remote-ws:main:vjp-remote-ws:roles/iam.serviceAccountUser"]',
        ],
    },
    var_files = [
        "//accounts/gcp:vjp-github-actions_tfvars",
    ],
)
