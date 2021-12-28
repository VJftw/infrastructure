terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "4.5.0"
    }
  }
}


data "google_organization" "org" {
  domain = "vjpatel.me"
}

data "google_billing_account" "billing" {
  display_name = "My Billing Account"
  open         = true
}

resource "google_project" "github_actions" {
  name                = "Github Actions"
  project_id          = "vjp-github-actions"
  org_id              = data.google_organization.org.org_id
  folder_id           = null
  billing_account     = data.google_billing_account.billing.id
  skip_delete         = false # Everything is generateable from code, so we can start from fresh for Disaster Recovery.
  auto_create_network = false
}


resource "google_project_service" "iam" {
  project = google_project.github_actions.project_id

  service = "iam.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "iamcredentials" {
  project = google_project.github_actions.project_id

  service = "iamcredentials.googleapis.com"

  disable_dependent_services = true
}
