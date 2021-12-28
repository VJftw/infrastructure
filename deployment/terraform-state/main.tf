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

resource "google_project_service" "cloudresourcemanager" {
  project = google_project.terraform_state.project_id
  service = "cloudresourcemanager.googleapis.com"

  disable_dependent_services = true
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
