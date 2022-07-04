output "google_workspace_domain_wide_delegation_configuration" {
  value = merge(
    {
      for rb in local.repository_branches : 
        google_service_account.branch["${rb.repo}:${rb.branch}"].id => {
          "email": google_service_account.branch["${rb.repo}:${rb.branch}"].email,
          "Client ID (unique_id)": google_service_account.branch["${rb.repo}:${rb.branch}"].unique_id,
          "scopes": sort(lookup(local.repositories[rb.repo]["branches"][rb.branch], "workspace_scopes", [])),
        }
        if lookup(local.repositories[rb.repo]["branches"][rb.branch], "workspace_scopes", []) != []
    },
    {
    for rp in local.repository_prs : 
      google_service_account.pr[rp.repo].id => {
        "email": google_service_account.pr[rp.repo].email,
        "Client ID (unique_id)": google_service_account.pr[rp.repo].unique_id,
        "scopes": sort(lookup(local.repositories[rp.repo]["pull_requests"], "workspace_scopes", [])),
      }
      if lookup(local.repositories[rp.repo]["pull_requests"], "workspace_scopes", []) != []
    }
  )
  description = <<EOF
  Visit https://admin.google.com/u/1/ac/owl/domainwidedelegation configure the
  clients with this value.
  EOF
}
