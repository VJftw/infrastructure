output "account_id" {
  value = aws_organizations_account.account.id
}

output "role_name" {
  value = aws_organizations_account.account.role_name
}

output "signin_url" {
  value = "https://${aws_iam_account_alias.alias.account_alias}.signin.aws.amazon.com/console/"
}
