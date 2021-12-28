locals {
  github_repository_roles = {
    "VJftw/org-infra" = {
      "organization" = ["roles/owner", "roles/resourcemanager.organizationAdmin"]
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
}
