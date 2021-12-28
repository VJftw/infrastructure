resource "google_iam_workload_identity_pool" "github_actions" {
  provider                  = google-beta
  project = google_project.github_actions.project_id
  
  workload_identity_pool_id = "github-actions"
  display_name = "GitHub Actions"
  disabled = false
}

resource "google_iam_workload_identity_pool_provider" "github_actions" {
  provider                           = google-beta
  project = google_project.github_actions.project_id

  workload_identity_pool_id          = google_iam_workload_identity_pool.github_actions.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-actions"
  display_name                       = "GitHub Actions"
  description                        = "OIDC identity pool provider for GitHub Actions"
  disabled                           = false

  attribute_mapping                  = {
    "google.subject" = "assertion.sub"
    "attribute.actor" = "assertion.actor"
    "attribute.repository" = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
  }
  
  oidc {
    issuer_uri        = "https://token.actions.githubusercontent.com"
  }
}


resource "google_service_account" "github_repository" {
  provider                           = google-beta
  project = google_project.github_actions.project_id


  for_each = local.github_repository_roles

  account_id   = "gha-${lower(replace(each.key, "/\\.|//", "-"))}"
  display_name = "GitHub Actions: ${each.key}"
  description = "GitHub Actions service account for ${each.key}"
}

resource "google_organization_iam_member" "github_repository" {
  for_each = toset(flatten([
    for gh_repo, config in local.github_repository_roles: [
      for role in lookup(config, "organization", []): [
        "${gh_repo}:${role}"
      ]
    ] 
  ]))

  org_id  = data.google_organization.org.id

  role    = split(":", each.key)[1]
  member = "serviceAccount:${google_service_account.github_repository[split(":", each.key)[0]].email}"
}

resource "google_project_iam_member" "github_repository" {
  provider                           = google-beta

  for_each = toset(flatten([
    for gh_repo, config in local.github_repository_roles: [
      for project, roles in lookup(config, "projects", {}): [
        for role in roles: ["${gh_repo}:${project}:${role}"]
      ]
    ] 
  ]))
  

  project = split(":", each.key)[1]

  role    = split(":", each.key)[2]

  member = "serviceAccount:${google_service_account.github_repository[split(":", each.key)[0]].email}"
}

resource "google_service_account_iam_binding" "github_repository" {
  provider                           = google-beta

  for_each = local.github_repository_roles

  service_account_id = google_service_account.github_repository[each.key].name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "principalSet://iam.googleapis.com/projects/${google_project.github_actions.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github_actions.workload_identity_pool_id}/attribute.repository/${each.key}",
  ]
}
