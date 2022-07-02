subinclude("//build/defs:terraform")

terraform_root(
    name = "aws",
    srcs = [
        "environments.tf",
        "main.tf",
        "organization.tf",
    ],
    account_auths = {
        "//accounts/aws:vjp-management_auth": {
            "branches": {
                "main": "administrator",
            },
            "pull_request": "reader",
        },
    },
)

# re-import
"""
$ plz run //deployment/org-policy/aws:aws -- bash
terraform init

terraform import "aws_organizations_organization.org" "o-6d75joro45"

terraform import "aws_organizations_organizational_unit.environment[\"management\"]" "ou-a31k-5nks08rt"
terraform import "aws_organizations_organizational_unit.environment[\"production\"]" "ou-a31k-5sdqthdv"
terraform import "aws_organizations_organizational_unit.environment[\"sandbox\"]" "ou-a31k-95t18y9o"

terraform import "aws_iam_role.organizational[\"account-creator\"]" "account-creator"
"""
