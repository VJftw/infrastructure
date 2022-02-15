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

provider "google-beta" {
  alias = "logs"

  project = "vjp-logs"
}
