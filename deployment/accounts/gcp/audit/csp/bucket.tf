resource "google_storage_bucket" "audit_csp" {
  provider = google-beta.logs

  name     = "${var.name}-audit-csp"
  location = "EUROPE-WEST1"

  uniform_bucket_level_access = true
  force_destroy = true

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

  # remove kms encryption because the keys are a little too expensive for me.
  # encryption {
  #   default_kms_key_name = module.kms.google_kms_crypto_key.id
  # }

  # depends_on = [
  #   google_kms_crypto_key_iam_binding.binding,
  # ]

}

# module "kms" {
#   source = "//modules/kms/gcp:gcp"

#   name     = "${var.name}-csp-audit"
#   location = "europe-west1"
#   providers = {
#     google-beta = google-beta.logs
#   }
# }

# data "google_storage_project_service_account" "logs" {
#   provider = google-beta.logs
# }

# resource "google_kms_crypto_key_iam_binding" "binding" {
#   provider = google-beta.logs

#   crypto_key_id = module.kms.google_kms_crypto_key.id
#   role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

#   members = ["serviceAccount:${data.google_storage_project_service_account.logs.email_address}"]
# }
