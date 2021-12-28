terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "4.5.0"
    }
  }
}

# provider "google" {
#  alias = "impersonation"
#  scopes = [
#    "https://www.googleapis.com/auth/cloud-platform",
#    "https://www.googleapis.com/auth/userinfo.email",
#  ]
# }

# data "google_service_account_access_token" "default" {
#  provider               	= google.impersonation
#  target_service_account 	= "gha-vjftw-org-infra@vjp-github-actions.iam.gserviceaccount.com"
#  scopes                 	= ["userinfo-email", "cloud-platform"]
#  lifetime               	= "1200s"
# }

# provider "google-beta" {
#  access_token	= data.google_service_account_access_token.default.access_token
#  request_timeout 	= "60s"
# }


data "google_organization" "org" {
  domain = "vjpatel.me"
}

data "google_billing_account" "billing" {
  display_name = "My Billing Account"
  open         = true
}

resource "google_project" "terraform_state" {
  name                = "Terraform Remote State"
  project_id          = "vjp-terraform-state"
  org_id              = data.google_organization.org.org_id
  folder_id           = null
  billing_account     = data.google_billing_account.billing.id
  skip_delete         = false # Everything is generateable from code, so we can start from fresh for Disaster Recovery.
  auto_create_network = false
}
