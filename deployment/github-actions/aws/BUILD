subinclude("//build/defs:terraform")

terraform_root(
    name = "aws",
    srcs = [
        "branches.tf",
        "main.tf",
        "oidc.tf",
        "pull-requests.tf",
        "repositories.yaml",
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
$ plz run //deployment/github-actions/aws:aws -- bash
terraform init

terraform import aws_iam_openid_connect_provider.github_actions "arn:aws:iam::400744676526:oidc-provider/token.actions.githubusercontent.com"

terraform import aws_iam_role.branch[\"VJftw/infrastructure:main\"] "gha-vjftw-infrastructure-main"
terraform import aws_iam_policy.branch[\"VJftw/infrastructure:main\"] "arn:aws:iam::400744676526:policy/gha-vjftw-infrastructure-main"
terraform import aws_iam_role.branch[\"VJftw/vjpatel.me:main\"] "gha-vjftw-vjpatel-me-main"
terraform import aws_iam_policy.branch[\"VJftw/vjpatel.me:main\"] "arn:aws:iam::400744676526:policy/gha-vjftw-vjpatel-me-main"

terraform import aws_iam_role.pr[\"VJftw/infrastructure\"] "ghapr-vjftw-infrastructure"
terraform import aws_iam_policy.pr[\"VJftw/infrastructure\"] "arn:aws:iam::400744676526:policy/ghapr-vjftw-infrastructure"
terraform import aws_iam_role.pr[\"VJftw/vjpatel.me\"] "ghapr-vjftw-vjpatel-me"
terraform import aws_iam_policy.pr[\"VJftw/vjpatel.me\"] "arn:aws:iam::400744676526:policy/ghapr-vjftw-vjpatel-me"
"""
