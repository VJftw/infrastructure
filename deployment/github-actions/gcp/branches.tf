locals {
  repository_branches = flatten([
    for gh_repo, config in local.repositories : [
      for branch, branch_config in lookup(config, "branches", {}) : {
        repo   = gh_repo,
        branch = branch,
      }
    ]
  ])

  repository_branch_organization_roles = flatten([
    for gh_repo, config in local.repositories : [
      for branch, branch_config in lookup(config, "branches", {}) : [
        for role in lookup(branch_config, "organization", []) : {
          repo   = gh_repo,
          branch = branch,
          role   = role,
        }
      ]
    ]
  ])

  repository_branch_per_folder_roles = flatten([
    for gh_repo, config in local.repositories : [
      for branch, branch_config in lookup(config, "branches", {}) : [
        for folder, roles in lookup(config, "folders", {}) : [
          for role in roles : {
            repo   = gh_repo,
            branch = branch,
            folder = folder,
            role   = role,
          }
        ]
      ]
    ]
  ])

  repository_branch_per_project_roles = flatten([
    for gh_repo, config in local.repositories : [
      for branch, branch_config in lookup(config, "branches", {}) : [
        for project, roles in lookup(config, "projects", {}) : [
          for role in roles : {
            repo    = gh_repo,
            branch  = branch,
            project = project,
            role    = role,
          }
        ]
      ]
    ]
  ])

  repository_branch_per_bucket_roles = flatten([
    for gh_repo, config in local.repositories : [
      for branch, branch_config in lookup(config, "branches", {}) : [
        for bucket, roles in lookup(config, "buckets", {}) : [
          for role in roles : {
            repo   = gh_repo,
            branch = branch,
            bucket = bucket,
            role   = role,
          }
        ]
      ]
    ]
  ])

  repository_branch_per_billing_account_roles = flatten([
    for gh_repo, config in local.repositories : [
      for branch, branch_config in lookup(config, "branches", {}) : [
        for billing_account, roles in lookup(config, "billing_accounts", {}) : [
          for role in roles : {
            repo            = gh_repo,
            branch          = branch,
            billing_account = billing_account,
            role            = role,
          }
        ]
      ]
    ]
  ])

}

resource "google_service_account" "branch" {
  provider = google-beta
  project  = module.project.project_id

  for_each = {
    for rb in local.repository_branches : "${rb.repo}:${rb.branch}" => rb
  }

  # gha = GitHub Actions
  account_id   = "gha-${lower(replace(each.value.repo, "/\\.|//", "-"))}-${each.value.branch}"
  display_name = "${each.value.repo}: ${each.value.branch}"
  description  = "Github Actions for '${each.value.repo}' on '${each.value.branch}'"
}

resource "google_service_account_iam_member" "branch" {
  provider = google-beta

  for_each = {
    for rb in local.repository_branches : "${rb.repo}:${rb.branch}" => rb
  }

  service_account_id = google_service_account.branch["${each.value.repo}:${each.value.branch}"].name
  role               = "roles/iam.workloadIdentityUser"

  member = join("/", [
    "principal://iam.googleapis.com/projects/${module.project.number}",
    "locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github_actions.workload_identity_pool_id}",
    # repo:octo-org/octo-repo:ref:refs/heads/demo-branch
    "subject/repo:${each.value.repo}:ref:refs/heads/${each.value.branch}",
  ])
}

resource "google_organization_iam_member" "branch" {
  provider = google-beta

  for_each = {
    for rbor in local.repository_branch_organization_roles : "${rbor.repo}:${rbor.branch}:${rbor.role}" => rbor
  }

  org_id = trimprefix(data.google_organization.org.id, "organizations/")
  role   = each.value.role

  member = "serviceAccount:${google_service_account.branch["${each.value.repo}:${each.value.branch}"].email}"
}

resource "google_folder_iam_member" "branch" {
  provider = google-beta

  for_each = {
    for rbfr in local.repository_branch_per_folder_roles : "${rbfr.repo}:${rbfr.branch}:${rbfr.folder}:${rbfr.role}" => rbfr
  }


  folder = local.folder_names[each.value.folder]
  role   = each.value.role

  member = "serviceAccount:${google_service_account.branch["${each.value.repo}:${each.value.branch}"].email}"
}


resource "google_project_iam_member" "branch" {
  provider = google-beta

  for_each = {
    for rbpr in local.repository_branch_per_project_roles : "${rbpr.repo}:${rbpr.branch}:${rbpr.project}:${rbpr.role}" => rbpr
  }


  project = each.value.project
  role    = each.value.role

  member = "serviceAccount:${google_service_account.branch["${each.value.repo}:${each.value.branch}"].email}"
}


resource "google_storage_bucket_iam_member" "branch" {
  provider = google-beta

  for_each = {
    for rbbr in local.repository_branch_per_bucket_roles : "${rbbr.repo}:${rbbr.branch}:${rbbr.bucket}:${rbbr.role}" => rbbr
  }

  bucket = each.value.bucket
  role   = each.value.role

  member = "serviceAccount:${google_service_account.branch["${each.value.repo}:${each.value.branch}"].email}"
}

data "google_billing_account" "branch" {
  provider = google-beta

  for_each = toset([for rbbr in local.repository_branch_per_billing_account_roles : rbbr.billing_account])

  display_name = "My Billing Account"
  open         = true
}

resource "google_billing_account_iam_member" "branch" {
  provider = google-beta

  for_each = {
    for rbbr in local.repository_branch_per_billing_account_roles : "${rbbr.repo}:${rbbr.branch}:${rbbr.billing_account}:${rbbr.role}" => rbbr
  }

  billing_account_id = data.google_billing_account.branch[each.value.billing_account].id
  role               = each.value.role

  member = "serviceAccount:${google_service_account.branch["${each.value.repo}:${each.value.branch}"].email}"
}
