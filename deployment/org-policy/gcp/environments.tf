locals {
  environments = [
    "management",
    "production",
    "sandbox",
  ]
}

resource "google_folder" "environment" {
  for_each = toset(local.environments)

  display_name = each.key
  parent       = data.google_organization.org.name
}
