locals {
  github_repository_roles = {
    "VJftw/org-infra" = {
      "organization" = ["roles/owner", "roles/resourcemanager.organizationAdmin", "roles/billing.admin"]
    }
    # "VJftw/vjpatel.me" = {
    #   # "organization" = ["roles/owner"]
    #   "projects" = {
    #     "vjftw-main" = ["roles/owner"]
    #   }
    # },
    # "VJftw/bastion" = {
    #   "projects" = {
    #     "vjftw-bastion-demo" = ["roles/owner"]
    #   }
    # }
  }

  # services which GitHub Actions can use.
  services = [
    "billingbudgets.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
  ]
}

resource "google_project_service" "github_actions" {
  provider                           = google-beta

  for_each = toset(local.services)

  project = google_project.github_actions.project_id
  service = each.key

  disable_dependent_services = true
}
