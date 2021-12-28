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
  project_id   = "vjp-sandbox-terraform-state"
  project_name = "Sandbox Terraform Remote State"

  folder_display_name = "sandbox"
}

module "terraform_remote_state" {
  source = "//modules/terraform-remote-state/gcp:gcp"

  project_id = module.project.project_id
}
