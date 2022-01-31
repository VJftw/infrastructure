locals {
  accounts = jsondecode(file("${path.module}/generated_accounts.json"))
}

module "account" {
  for_each = local.accounts

  source = "//modules/account/gcp:gcp"

  domain = "vjpatel.me"

  project_id   = each.key
  project_name = each.key

  folder_display_name = each.value.environment
}
