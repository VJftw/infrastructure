genrule(
    name = "accounts_json",
    srcs = ["//accounts/gcp"],
    outs = ["generated_accounts.json"],
    cmd = """
set -Eeuox pipefail
files=($(find accounts/ -type f -name '*.tfvars'))
echo '{}' > $OUTS

for f in "${files[@]}"; do

    $TOOLS \\
        --arg name "$(cat $f | grep 'name' | cut -f2 -d\\")" \\
        --arg environment "$(cat $f | grep 'environment' | cut -f2 -d\\")" \\
        '.[$name] = { environment: $environment }' \\
        $OUTS > ${OUTS}.new
    mv ${OUTS}.new $OUTS

done
    """,
    tools = ["//third_party/binary:jq"],
)

subinclude("//build/defs:terraform")

terraform_root(
    name = "gcp",
    srcs = [
        "accounts.tf",
        "main.tf",
        ":accounts_json",
    ],
    labels = ["accounts"],
    modules = [
        "//modules/account/gcp:gcp",
    ],
    opa_data = {
        "allowlist_deleted_addresses": [
            "module.account[\"secure-gke\"].google_project.account",
            "module.account[\"secure-gke-pr\"].google_project.account",
        ],
    },
)

# re-import
"""
$ plz run //deployment/accounts/gcp:gcp -- bash
terraform init
terraform import "module.account[\"vjp-cloud-desktops\"].google_project.account" "vjp-cloud-desktops"
terraform import "module.account[\"vjp-dns\"].google_project.account" "vjp-dns"
terraform import "module.account[\"vjp-github-actions\"].google_project.account" "vjp-github-actions"
terraform import "module.account[\"vjp-logs\"].google_project.account" "vjp-logs"
terraform import "module.account[\"vjp-remote-ws\"].google_project.account" "vjp-remote-ws"
terraform import "module.account[\"vjp-sandbox-terraform-state\"].google_project.account" "vjp-sandbox-terraform-state"
terraform import "module.account[\"vjp-terraform-state\"].google_project.account" "vjp-terraform-state"
"""
