locals {
  fn_id = "fn-${substr(sha1("${var.name}-kms-key-cleaner"), 0, 7)}"
}

resource "google_project_service" "cloudfunctions" {
  provider = google-beta

  service = "cloudfunctions.googleapis.com"

  disable_dependent_services = false

  depends_on = [
    google_project_service.cloudbuild,
  ]
}

resource "google_project_service" "cloudbuild" {
  provider = google-beta

  service = "cloudbuild.googleapis.com"

  disable_dependent_services = false
}

resource "google_cloudfunctions_function" "function" {
  provider = google-beta

  region = lower(var.location)

  name        = local.fn_id
  description = "Cleans up old KMS keys for ${var.name}"
  runtime     = "python39"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.function.name
  source_archive_object = google_storage_bucket_object.function.name
  entry_point           = "cleanup"

  service_account_email = google_service_account.function.email

  environment_variables = {
    CRYPTO_KEY_ID = google_kms_crypto_key.this.id
  }

  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.function_trigger.id
  }

  depends_on = [
    google_project_service.cloudfunctions,
    google_project_service.cloudbuild,
  ]
}

resource "google_service_account" "function" {
  provider = google-beta

  account_id   = local.fn_id
  display_name = "${var.name}-kms-key-cleaner"
}

resource "google_storage_bucket" "function" {
  provider = google-beta

  name          = local.fn_id
  location      = upper(var.location)
  force_destroy = true

  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "function" {
  provider = google-beta

  name   = "cleanup-kms-key-versions.${data.archive_file.function.output_md5}.zip"
  source = data.archive_file.function.output_path
  bucket = google_storage_bucket.function.name
}

data "archive_file" "function" {
  type = "zip"

  source {
    content  = file("${path.module}/main.py")
    filename = "main.py"
  }

  source {
    content  = file("${path.module}/requirements.txt")
    filename = "requirements.txt"
  }

  output_path = "${path.module}/cleanup-kms-key-versions.zip"
}

resource "google_pubsub_topic" "function_trigger" {
  provider = google-beta

  name = "${local.fn_id}-trigger"

  message_retention_duration = "600s"
}

resource "google_project_service" "cloudscheduler" {
  provider = google-beta

  service = "cloudscheduler.googleapis.com"

  disable_dependent_services = true
}

resource "google_cloud_scheduler_job" "function_trigger" {
  provider = google-beta

  region = "europe-west1"

  name        = "${local.fn_id}-cron"
  description = "${var.name}-kms-key-cleaner-cron"
  schedule    = "0 0 1,15 * *"

  pubsub_target {
    topic_name = google_pubsub_topic.function_trigger.id
    data       = base64encode("{}")
  }

  depends_on = [
    google_project_service.cloudscheduler,
  ]
}

resource "google_kms_crypto_key_iam_binding" "this" {
  provider = google-beta

  crypto_key_id = google_kms_crypto_key.this.id
  role          = "roles/cloudkms.admin"

  members = [
    "serviceAccount:${google_service_account.function.email}",
  ]
}
