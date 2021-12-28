resource "google_storage_bucket" "terraform_state" {
  project       = google_project.terraform_state.project_id

  name          = google_project.terraform_state.project_id
  location      = "EUROPE-WEST2"
  force_destroy = true

  uniform_bucket_level_access = true
  
  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      num_newer_versions = 5
      age = 30
    }

    action {
      type = "Delete"
    }
  }

  encryption {
    default_kms_key_name = google_kms_crypto_key.terraform_state.id
  }

}

resource "google_project_service" "cloudkms" {
  project = google_project.terraform_state.project_id
  service = "cloudkms.googleapis.com"

  disable_dependent_services = true
}


resource "google_kms_key_ring" "terraform_state" {
  project       = google_project.terraform_state.project_id

  name     = "terraform-state"
  location = "europe-west2"

  depends_on = [
    google_project_service.cloudkms,
  ]
}

resource "google_kms_crypto_key" "terraform_state" {
  name            = "terraform-state"
  key_ring        = google_kms_key_ring.terraform_state.id
  rotation_period = "86400s"

  lifecycle {
    prevent_destroy = true
  }
}

data "google_storage_project_service_account" "gcs_account" {
  project = google_project.terraform_state.project_id
}

resource "google_kms_crypto_key_iam_binding" "binding" {
  crypto_key_id = google_kms_crypto_key.terraform_state.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = ["serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"]
}
