genrule(
    name = "accounts_json",
    srcs = ["//accounts/aws"],
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
    name = "aws",
    srcs = [
        "accounts.tf",
        "main.tf",
        ":accounts_json",
    ],
    account_auths = {
        "//accounts/aws:vjp-management_auth": {
            "branches": {
                "main": "administrator",
            },
            "pull_request": "reader",
        },
    },
    labels = ["accounts"],
    modules = [
        "//modules/account/aws:aws",
    ],
)

# re-import
"""
$ plz run //deployment/accounts/aws:aws -- bash
terraform init
terraform import "module.account[\"vjp-dns\"].aws_organizations_account.account" "436856999079"
terraform import "module.account[\"vjp-homomorphic-encryption\"].aws_organizations_account.account" "105193361835"
terraform import "module.account[\"vjp-logs\"].aws_organizations_account.account" "413999795292"
terraform import "module.account[\"vjp-management\"].aws_organizations_account.account" "400744676526"
terraform import "module.account[\"vjp-website\"].aws_organizations_account.account" "447409662917"

terraform state pull > terraform.tfstate
sed -i 's#"iam_user_access_to_billing": null#"iam_user_access_to_billing": "ALLOW"#g' terraform.tfstate
sed -i 's#"role_name": null#"role_name": "OrganizationAccountAccessRole"#g' terraform.tfstate
terraform state push terraform.tfstate
"""
