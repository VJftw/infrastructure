resource "google_storage_bucket" "audit_csp" {
  provider = google-beta.logs

  name     = "${var.name}-audit-csp"
  location = "EUROPE-WEST1"

  uniform_bucket_level_access = true

  lifecycle_rule {
    condition {
      age = 3
    }
    action {
      type          = "SetStorageClass"
      storage_class = "ARCHIVE"
    }
  }

  lifecycle_rule {
    condition {
      age = 14
    }
    action {
      type = "Delete"
    }
  }

  retention_policy {
    is_locked        = true
    retention_period = 86400 * 3 # 3 days in seconds
  }

  encryption {
    default_kms_key_name = google_kms_crypto_key.audit_csp.id
  }

  depends_on = [
    google_kms_crypto_key_iam_binding.binding,
  ]

}

resource "google_project_service" "cloudkms" {
  provider = google-beta.logs

  service = "cloudkms.googleapis.com"

  disable_dependent_services = true
}


resource "google_kms_key_ring" "audit_csp" {
  provider = google-beta.logs

  name     = "${var.name}-audit-csp"
  location = "europe-west1"

  depends_on = [
    google_project_service.cloudkms,
  ]
}

resource "google_kms_crypto_key" "audit_csp" {
  provider = google-beta.logs

  name            = "${var.name}-audit-csp"
  key_ring        = google_kms_key_ring.audit_csp.id
  rotation_period = "1209600s" # 2 weeks

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_kms_crypto_key_iam_binding" "audit_csp" {
  provider = google-beta.logs

  crypto_key_id = google_kms_crypto_key.audit_csp.id
  role          = "roles/cloudkms.admin"

  members = [
    "serviceAccount:${google_service_account.function.email}",
  ]
}

data "google_storage_project_service_account" "logs" {
  provider = google-beta.logs
}

resource "google_kms_crypto_key_iam_binding" "binding" {
  provider = google-beta.logs

  crypto_key_id = google_kms_crypto_key.audit_csp.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = ["serviceAccount:${data.google_storage_project_service_account.logs.email_address}"]
}
