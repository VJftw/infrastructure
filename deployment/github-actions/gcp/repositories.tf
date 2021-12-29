locals {
  github_repository_roles = {
    "VJftw/org-infra" = {
      "organization" = [
        "roles/owner",
        "roles/resourcemanager.organizationAdmin",
        "roles/resourcemanager.folderAdmin",
        "roles/resourcemanager.folderIamAdmin",
        "roles/billing.admin",
        "roles/orgpolicy.policyAdmin",
      ]
      "pull_request" = {
        "organization" = [
          "roles/viewer",
          "roles/resourcemanager.organizationViewer",
          "roles/resourcemanager.folderViewer",
          "roles/billing.viewer",
          "roles/iam.securityReviewer",
          "roles/orgpolicy.policyViewer",
        ]
      }
    }
    "VJftw/bastion" = {
      "organization" = ["roles/billing.viewer"]
      "folders" = {
        "sandbox" = [
          "roles/resourcemanager.projectCreator",
          "roles/resourcemanager.projectDeleter",
          "roles/owner",
        ]
      }
      "pull_request" = {
        "organization" = ["roles/billing.viewer"]
        "folders" = {
          "sandbox" = [
            "roles/owner", // allow Terratest in Sandbox only during PRs
            "roles/resourcemanager.folderViewer",
            "roles/iam.securityReviewer",
          ]
        }
      }
    }
    # "VJftw/vjpatel.me" = {
    #   # "organization" = ["roles/owner"]
    #   "projects" = {
    #     "vjftw-main" = ["roles/owner"]
    #   }
    # },
  }

}
