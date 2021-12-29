locals {
  /* github_repository_roles
  This object defines the GCP role bindings to apply in the following structure:
  <GitHub Repository>:
    organization: list of roles to apply at the organization level for actions against the 'main' branch.
    folders:
      <folder_name>: list of roles to apply at the per-folder level for actions against the 'main' branch.
    projects:
      <project_name>: list of roles to apply at the per-project level for actions against the 'main' branch.
    pull_request:
      organization: list of roles to apply at the organization level for actions against Pull Requests.
      folders:
        <folder_name>: list of roles to apply at the per-folder level for actions against Pull Requests.
      projects:
        <project_name>: list of roles to apply at the per-project level for actions against Pull Requests.
*/
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
    "VJftw/cloud-bastion-tunnel" = {
      "organization" = [
        "roles/viewer",
        "roles/resourcemanager.organizationViewer",
        "roles/resourcemanager.folderViewer",
        "roles/billing.viewer",
        "roles/iam.securityReviewer",
      ]
      "folders" = {
        "sandbox" = [
          "roles/resourcemanager.projectCreator",
          "roles/resourcemanager.projectDeleter",
          "roles/owner",
        ]
      }
      "pull_request" = {
        "organization" = [
          "roles/viewer",
          "roles/resourcemanager.organizationViewer",
          "roles/resourcemanager.folderViewer",
          "roles/billing.viewer",
          "roles/iam.securityReviewer",
        ]
        "folders" = {
          "sandbox" = [
            "roles/resourcemanager.projectCreator",
            "roles/resourcemanager.projectDeleter",
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
