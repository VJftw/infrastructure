locals {
  fn_id = "fn-${substr(sha1("${data.google_project.project.project_id}-re-encrypter"), 0, 7)}"
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

  region = "europe-west2"

  name        = local.fn_id
  description = "Re-encrypts all objects in ${data.google_project.project.project_id}"
  runtime     = "python39"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.function.name
  source_archive_object = google_storage_bucket_object.function.name
  entry_point           = "re_encrypt"

  service_account_email = google_service_account.function.email

  environment_variables = {
    STORAGE_BUCKET = google_storage_bucket.terraform_state.name
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
  display_name = "${data.google_project.project.project_id}-re-encrpyter"
}

resource "google_storage_bucket" "function" {
  provider = google-beta

  name          = local.fn_id
  location      = "EUROPE-WEST2"
  force_destroy = true

  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "function" {
  provider = google-beta

  name   = "re-encrypter.${data.archive_file.function.output_md5}.zip"
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

  output_path = "${path.module}/re-encrypter.zip"
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
  description = "${data.google_project.project.project_id}-re-encrypter-cron"
  schedule    = "0 6 1,15 * *"

  pubsub_target {
    topic_name = google_pubsub_topic.function_trigger.id
    data       = base64encode("{}")
  }

  depends_on = [
    google_project_service.cloudscheduler,
  ]
}

resource "google_storage_bucket_iam_binding" "this" {
  provider = google-beta

  bucket = google_storage_bucket.terraform_state.id
  role          = "roles/storage.admin"

  members = [
    "serviceAccount:${google_service_account.function.email}",
  ]
}
