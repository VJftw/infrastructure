locals {
  repository_prs = flatten([
    for gh_repo, config in local.repositories : {
      repo = gh_repo,
    }
  ])

  repository_pr_organization_roles = flatten([
    for gh_repo, config in local.repositories : [
      for role in lookup(lookup(config, "pull_requests", {}), "organization", []) : {
        repo = gh_repo,
        role = role,
      }
    ]
  ])

  repository_pr_per_folder_roles = flatten([
    for gh_repo, config in local.repositories : [
      for folder, roles in lookup(lookup(config, "pull_requests", {}), "folders", {}) : [
        for role in roles : {
          repo   = gh_repo,
          folder = folder,
          role   = role,
        }
      ]
    ]
  ])

  repository_pr_per_project_roles = flatten([
    for gh_repo, config in local.repositories : [
      for project, roles in lookup(lookup(config, "pull_requests", {}), "projects", {}) : [
        for role in roles : {
          repo    = gh_repo,
          project = project,
          role    = role,
        }
      ]
    ]
  ])

  repository_pr_per_bucket_roles = flatten([
    for gh_repo, config in local.repositories : [
      for bucket, roles in lookup(lookup(config, "pull_requests", {}), "buckets", {}) : [
        for role in roles : {
          repo   = gh_repo,
          bucket = bucket,
          role   = role,
        }
      ]
    ]
  ])

  repository_pr_per_billing_account_roles = flatten([
    for gh_repo, config in local.repositories : [
      for billing_account, roles in lookup(lookup(config, "pull_requests", {}), "billing_accounts", {}) : [
        for role in roles : {
          repo            = gh_repo,
          billing_account = billing_account,
          role            = role,
        }
      ]
    ]
  ])

}

resource "google_service_account" "pr" {
  provider = google-beta
  project  = var.name

  for_each = {
    for rb in local.repository_prs : rb.repo => rb
  }

  # ghapr = GitHub Actions Pull Request
  account_id   = "ghapr-${lower(replace(each.value.repo, "/\\.|//", "-"))}"
  display_name = "${each.value.repo}: Pull Requests"
  description  = "Github Actions for Pull Requests on '${each.value.repo}'"
}

resource "google_service_account_iam_member" "pr" {
  provider = google-beta

  for_each = {
    for rb in local.repository_prs : rb.repo => rb
  }

  service_account_id = google_service_account.pr[each.value.repo].name
  role               = "roles/iam.workloadIdentityUser"

  member = join("/", [
    "principal://iam.googleapis.com/projects/${data.google_project.this.number}",
    "locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github_actions.workload_identity_pool_id}",
    # repo:octo-org/octo-repo:pull_request
    "subject/repo:${each.value.repo}:pull_request",
  ])

}

resource "google_organization_iam_member" "pr" {
  provider = google-beta

  for_each = {
    for rbor in local.repository_pr_organization_roles : "${rbor.repo}:${rbor.role}" => rbor
  }

  org_id = trimprefix(data.google_organization.org.id, "organizations/")
  role   = each.value.role

  member = "serviceAccount:${google_service_account.pr[each.value.repo].email}"
}

resource "google_folder_iam_member" "pr" {
  provider = google-beta

  for_each = {
    for rbfr in local.repository_pr_per_folder_roles : "${rbfr.repo}:${rbfr.folder}:${rbfr.role}" => rbfr
  }


  folder = local.folder_names[each.value.folder]
  role   = each.value.role

  member = "serviceAccount:${google_service_account.pr[each.value.repo].email}"
}


resource "google_project_iam_member" "pr" {
  provider = google-beta

  for_each = {
    for rbpr in local.repository_pr_per_project_roles : "${rbpr.repo}:${rbpr.project}:${rbpr.role}" => rbpr
  }


  project = each.value.project
  role    = each.value.role

  member = "serviceAccount:${google_service_account.pr[each.value.repo].email}"
}


resource "google_storage_bucket_iam_member" "pr" {
  provider = google-beta

  for_each = {
    for rbbr in local.repository_pr_per_bucket_roles : "${rbbr.repo}:${rbbr.bucket}:${rbbr.role}" => rbbr
  }

  bucket = each.value.bucket
  role   = each.value.role

  member = "serviceAccount:${google_service_account.pr[each.value.repo].email}"
}

data "google_billing_account" "pr" {
  provider = google-beta

  for_each = toset([for rbbr in local.repository_pr_per_billing_account_roles : rbbr.billing_account])

  display_name = "My Billing Account"
  open         = true
}

resource "google_billing_account_iam_member" "pr" {
  provider = google-beta

  for_each = {
    for rbbr in local.repository_pr_per_billing_account_roles : "${rbbr.repo}:${rbbr.billing_account}:${rbbr.role}" => rbbr
  }

  billing_account_id = data.google_billing_account.pr[each.value.billing_account].id
  role               = each.value.role

  member = "serviceAccount:${google_service_account.pr[each.value.repo].email}"
}
