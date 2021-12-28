locals {
  github_repository_roles = {
    "VJftw/org-infra" = {
      "organization" = [
        "roles/owner",
        "roles/resourcemanager.organizationAdmin",
        "roles/billing.admin",
      ]
      "pull_request" = {
        "organization" = [
          "roles/viewer",
          "roles/resourcemanager.organizationViewer",
          "roles/billing.viewer",
          "roles/iam.securityReviewer",
        ]
      }
    }
    "VJftw/bastion" = {
      "folders" = {
        "sandbox" = [
          "roles/resourcemanager.projectCreator",
          "roles/resourcemanager.projectDeleter",
        ]
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
