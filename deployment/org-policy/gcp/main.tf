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
