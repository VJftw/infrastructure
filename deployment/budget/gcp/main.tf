terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "4.5.0"
    }
  }
}

provider "google-beta" {
}

data "google_organization" "org" {
  domain = "vjpatel.me"
}

data "google_billing_account" "billing" {
  display_name = "My Billing Account"
  open         = true
}

resource "google_billing_budget" "budget" {
  provider = google-beta
  billing_account = data.google_billing_account.billing.id

  display_name = "Default"

  amount {
    specified_amount {
      currency_code = "GBP"
      units         = "50"
    }
  }

  threshold_rules {
    threshold_percent = 0.75
  }
}
