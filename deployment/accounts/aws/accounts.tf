locals {
  accounts = jsondecode(file("${path.module}/generated_accounts.json"))
}

module "account" {
  for_each = local.accounts

  source = "//modules/account/aws:aws"

  providers = {
    aws.management = aws
  }

  base_email = "aws@vjpatel.me"

  name                     = each.key
  organizational_unit_name = each.value.environment
}
