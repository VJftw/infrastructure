resource "google_logging_project_sink" "audit_csp" {
  provider = google-beta

  name = "audit-csp"

  destination = "storage.googleapis.com/${google_storage_bucket.audit_csp.name}"

  # Log all WARN or higher severity messages relating to instances
  # filter = "resource.type = gce_instance AND severity >= WARNING"

  unique_writer_identity = true

  depends_on = [
    google_project_service.logging,
  ]
}

resource "google_project_service" "logging" {
  provider = google-beta

  service = "logging.googleapis.com"

  disable_dependent_services = true
}
