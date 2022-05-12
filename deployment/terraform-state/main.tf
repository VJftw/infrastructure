terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "4.5.0"
    }
  }
}

provider "google-beta" {
  project = var.name
}

module "terraform_remote_state" {
  source = "//modules/terraform-remote-state/gcp:gcp"

  providers = {
    google-beta = google-beta
  }
}
