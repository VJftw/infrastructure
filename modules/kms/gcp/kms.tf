resource "google_project_service" "cloudkms" {
  provider = google-beta

  service = "cloudkms.googleapis.com"

  disable_dependent_services = false

  disable_on_destroy = false
}


resource "google_kms_key_ring" "this" {
  provider = google-beta

  name     = var.name
  location = lower(var.location)

  depends_on = [
    google_project_service.cloudkms,
  ]
}

resource "google_kms_crypto_key" "this" {
  provider = google-beta

  name            = var.name
  key_ring        = google_kms_key_ring.this.id
  # rotation_period = "1209600s" # 2 weeks
}
