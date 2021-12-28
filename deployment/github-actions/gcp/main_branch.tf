resource "google_service_account" "github_repository" {
  provider = google-beta
  project  = module.project.project_id


  for_each = local.github_repository_roles

  account_id   = "gha-${lower(replace(each.key, "/\\.|//", "-"))}"
  display_name = "GitHub Actions: ${each.key}"
  description  = "GitHub Actions service account for ${each.key}"
}

resource "google_storage_bucket_iam_member" "github_repository" {
  for_each = local.github_repository_roles

  bucket = "vjp-terraform-state"
  role   = "roles/storage.objectAdmin"

  member = "serviceAccount:${google_service_account.github_repository[each.key].email}"
}

resource "google_organization_iam_member" "github_repository" {
  provider = google-beta

  for_each = toset(flatten([
    for gh_repo, config in local.github_repository_roles : [
      for role in lookup(config, "organization", []) : [
        "${gh_repo}:${role}"
      ]
    ]
  ]))

  org_id = trimprefix(data.google_organization.org.id, "organizations/")

  role   = split(":", each.key)[1]
  member = "serviceAccount:${google_service_account.github_repository[split(":", each.key)[0]].email}"
}

resource "google_folder_iam_member" "github_repository" {
  provider = google-beta

  for_each = toset(flatten([
    for gh_repo, config in local.github_repository_roles : [
      for folder, roles in lookup(config, "folders", {}) : [
        for role in roles : ["${gh_repo}:${folder}:${role}"]
      ]
    ]
  ]))


  folder = local.folder_names[split(":", each.key)[1]]

  role = split(":", each.key)[2]

  member = "serviceAccount:${google_service_account.github_repository[split(":", each.key)[0]].email}"
}

resource "google_project_iam_member" "github_repository" {
  provider = google-beta

  for_each = toset(flatten([
    for gh_repo, config in local.github_repository_roles : [
      for project, roles in lookup(config, "projects", {}) : [
        for role in roles : ["${gh_repo}:${project}:${role}"]
      ]
    ]
  ]))


  project = split(":", each.key)[1]

  role = split(":", each.key)[2]

  member = "serviceAccount:${google_service_account.github_repository[split(":", each.key)[0]].email}"
}

resource "google_service_account_iam_member" "github_repository" {
  provider = google-beta

  for_each = local.github_repository_roles

  service_account_id = google_service_account.github_repository[each.key].name
  role               = "roles/iam.workloadIdentityUser"

  # member = "principalSet://iam.googleapis.com/projects/${module.project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github_actions.workload_identity_pool_id}/attribute.repository/${each.key}"

  member = join("/", [
    "principal://iam.googleapis.com/projects/${module.project.number}",
    "locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github_actions.workload_identity_pool_id}",
    # repo:octo-org/octo-repo:ref:refs/heads/demo-branch
    # limit to just the main branch of repositories
    "subject/repo:${each.key}:ref:refs/heads/main",
  ])
}

resource "google_billing_account_iam_member" "github_actions" {
  provider = google-beta

  for_each = local.github_repository_roles

  billing_account_id = data.google_billing_account.billing.id
  role               = "roles/billing.user"

  # member = "principalSet://iam.googleapis.com/projects/${module.project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github_actions.workload_identity_pool_id}/attribute.repository/${each.key}"

  member = join("/", [
    "principal://iam.googleapis.com/projects/${module.project.number}",
    "locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github_actions.workload_identity_pool_id}",
    # repo:octo-org/octo-repo:ref:refs/heads/demo-branch
    # limit to just the main branch of repositories
    "subject/repo:${each.key}:ref:refs/heads/main",
  ])
}
