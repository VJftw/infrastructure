resource "google_storage_bucket" "terraform_state" {
  provider = google-beta

  name          = data.google_project.project.project_id # we use Projects as security boundaries
  location      = "EUROPE-WEST2"
  force_destroy = true

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      num_newer_versions = 5
      age                = 30
    }

    action {
      type = "Delete"
    }
  }

  # Use default encryption to reduce costs.
  # encryption {
  #   default_kms_key_name = module.kms.google_kms_crypto_key.id
  # }

  # depends_on = [
  #   google_kms_crypto_key_iam_binding.binding,
  # ]

}

# Use default encryption to reduce costs.
# module "kms" {
#   source = "//modules/kms/gcp:gcp"

#   name = "${data.google_project.project.project_id}-terraform-state-bucket"
#   location = "europe-west2"
#   providers = {
#     google-beta = google-beta
#   } 
# }

# data "google_storage_project_service_account" "gcs_account" {
#   provider = google-beta
# }

# resource "google_kms_crypto_key_iam_binding" "binding" {
#   provider = google-beta

#   crypto_key_id = "vjp-sandbox-terraform-state/europe-west2/vjp-sandbox-terraform-state-terraform-state-bucket/vjp-sandbox-terraform-state-terraform-state-bucket"
#   role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

#   members = ["serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"]
# }
