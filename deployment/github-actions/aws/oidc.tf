resource "aws_iam_openid_connect_provider" "github_actions" {
  provider = aws.management

  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = []
}
