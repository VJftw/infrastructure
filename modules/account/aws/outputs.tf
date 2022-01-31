output "account_id" {
  value = aws_organizations_account.account.id
}

output "role_name" {
  value = aws_organizations_account.account.role_name
}

output "account_name" {
  value = aws_organizations_account.account.name
}
