resource "aws_iam_account_alias" "alias" {
  provider = aws.account

  account_alias = var.name
}
