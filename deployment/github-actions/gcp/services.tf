locals {
  /* 
  Service APIs which GitHub Actions can use. 
  These are enabled in the github-actions Project as that is where the impersonated Service Account lives.
  */
  services = [
    "billingbudgets.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudkms.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "container.googleapis.com",
    "serviceusage.googleapis.com",
  ]
}

resource "google_project_service" "github_actions" {
  provider = google-beta

  for_each = toset(local.services)

  project = module.project.project_id
  service = each.key

  disable_dependent_services = true
}
