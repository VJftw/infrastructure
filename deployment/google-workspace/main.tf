terraform {
  required_providers {
    googleworkspace = {
      source = "hashicorp/googleworkspace"
      version = "0.6.0"
    }
  }
}

data "google_service_account_access_token" "default" {
  provider               = google
  target_service_account = "service_B@projectB.iam.gserviceaccount.com"
  scopes                 = ["userinfo-email", "cloud-platform"]
  lifetime               = "300s"
}

provider "googleworkspace" {
  // From https://admin.google.com/u/1/ac/accountsettings/profile
  customer_id = "C03kuz6ig"
}
