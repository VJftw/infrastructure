terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "4.5.0"
    }
  }
}

module "project" {
  source = "//modules/account/gcp:gcp"

  domain       = "vjpatel.me"
  project_id   = "vjp-terraform-state"
  project_name = "Terraform Remote State"

  folder_display_name = "management"
}
