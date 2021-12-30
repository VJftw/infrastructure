terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "4.5.0"
    }
  }
}

data "google_organization" "org" {
  provider = google-beta

  domain = "vjpatel.me"
}

data "google_billing_account" "billing" {
  provider = google-beta

  display_name = "My Billing Account"
  open         = true
}

data "google_folders" "folders" {
  parent_id = data.google_organization.org.name
}


locals {
  folder_names = { for folder in data.google_folders.folders.folders : folder.display_name => folder.name }

  repositories = yamldecode(file("repositories.yaml"))
}

module "project" {
  source = "//modules/account/gcp:gcp"

  domain       = "vjpatel.me"
  project_id   = "vjp-github-actions"
  project_name = "Github Actions"

  folder_display_name = "management"
}


resource "google_project_service" "iam" {
  provider = google-beta

  project = module.project.project_id

  service = "iam.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "iamcredentials" {
  provider = google-beta

  project = module.project.project_id

  service = "iamcredentials.googleapis.com"

  disable_dependent_services = true
}
