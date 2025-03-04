
data "google_organization" "org" {
  domain = var.domain
}

data "google_folders" "folders" {
  parent_id = data.google_organization.org.name
}

data "google_billing_account" "billing" {
  display_name = var.billing_account_display_name
  open         = true
}

locals {
  folder_ids = [for folder in data.google_folders.folders.folders: folder.name if folder.display_name == var.folder_display_name]
}

resource "google_project" "account" {
  name                = var.project_name
  project_id          = var.project_id
  org_id              = length(local.folder_ids) == 1 ? null : data.google_organization.org.org_id
  folder_id           = length(local.folder_ids) == 1 ? local.folder_ids[0] : null
  billing_account     = data.google_billing_account.billing.id
  auto_create_network = false
}
