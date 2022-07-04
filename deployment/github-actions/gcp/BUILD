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
        "outputs.tf",
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

# re-import
"""
$ plz run //deployment/github-actions/gcp:gcp -- bash
terraform init

terraform import google_iam_workload_identity_pool.github_actions projects/vjp-github-actions/locations/global/workloadIdentityPools/github-actions
terraform import google_iam_workload_identity_pool_provider.github_actions projects/vjp-github-actions/locations/global/workloadIdentityPools/github-actions/providers/github-actions

terraform import google_project_service.iam "vjp-github-actions/iam.googleapis.com"
terraform import google_project_service.iamcredentials "vjp-github-actions/iamcredentials.googleapis.com"
terraform import google_project_service.github_actions[\"billingbudgets.googleapis.com\"] "vjp-github-actions/billingbudgets.googleapis.com"
terraform import google_project_service.github_actions[\"cloudbilling.googleapis.com\"] "vjp-github-actions/cloudbilling.googleapis.com"
terraform import google_project_service.github_actions[\"cloudkms.googleapis.com\"] "vjp-github-actions/cloudkms.googleapis.com"
terraform import google_project_service.github_actions[\"cloudresourcemanager.googleapis.com\"] "vjp-github-actions/cloudresourcemanager.googleapis.com"
terraform import google_project_service.github_actions[\"compute.googleapis.com\"] "vjp-github-actions/compute.googleapis.com"
terraform import google_project_service.github_actions[\"container.googleapis.com\"] "vjp-github-actions/container.googleapis.com"
terraform import google_project_service.github_actions[\"serviceusage.googleapis.com\"] "vjp-github-actions/serviceusage.googleapis.com"
terraform import google_project_service.github_actions[\"dns.googleapis.com\"] "vjp-github-actions/dns.googleapis.com"
terraform import google_project_service.github_actions[\"logging.googleapis.com\"] "vjp-github-actions/logging.googleapis.com"

terraform import google_service_account.pr[\"VJftw/infrastructure\"] "projects/vjp-github-actions/serviceAccounts/ghapr-vjftw-infrastructure@vjp-github-actions.iam.gserviceaccount.com"
terraform import google_service_account.pr[\"VJftw/cloud-bastion\"] "projects/vjp-github-actions/serviceAccounts/ghapr-vjftw-cloud-bastion@vjp-github-actions.iam.gserviceaccount.com"
terraform import google_service_account.pr[\"VJftw/cloud-desktops\"] "projects/vjp-github-actions/serviceAccounts/ghapr-vjftw-cloud-desktops@vjp-github-actions.iam.gserviceaccount.com"
terraform import google_service_account.pr[\"VJftw/remote-ws\"] "projects/vjp-github-actions/serviceAccounts/ghapr-vjftw-remote-ws@vjp-github-actions.iam.gserviceaccount.com"
terraform import google_service_account.pr[\"VJftw/vjpatel.me\"] "projects/vjp-github-actions/serviceAccounts/ghapr-vjftw-vjpatel-me@vjp-github-actions.iam.gserviceaccount.com"

terraform import google_service_account.branch[\"VJftw/infrastructure:main\"] "projects/vjp-github-actions/serviceAccounts/gha-vjftw-infrastructure-main@vjp-github-actions.iam.gserviceaccount.com"
terraform import google_service_account.branch[\"VJftw/cloud-bastion:main\"] "projects/vjp-github-actions/serviceAccounts/gha-vjftw-cloud-bastion-main@vjp-github-actions.iam.gserviceaccount.com"
terraform import google_service_account.branch[\"VJftw/cloud-desktops:main\"] "projects/vjp-github-actions/serviceAccounts/gha-vjftw-cloud-desktops-main@vjp-github-actions.iam.gserviceaccount.com"
terraform import google_service_account.branch[\"VJftw/remote-ws:main\"] "projects/vjp-github-actions/serviceAccounts/gha-vjftw-remote-ws-main@vjp-github-actions.iam.gserviceaccount.com"
terraform import google_service_account.branch[\"VJftw/vjpatel.me:main\"] "projects/vjp-github-actions/serviceAccounts/gha-vjftw-vjpatel-me-main@vjp-github-actions.iam.gserviceaccount.com"
"""
