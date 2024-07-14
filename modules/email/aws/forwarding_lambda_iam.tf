resource "aws_iam_role" "lambda" {
  name = "forwarding_lambda-${local.clean_domain}"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_policy" "lambda" {
  name        = "forwarding_lambda-${local.clean_domain}"
  description = "IAM Policy to allow forwarding lambda to ready and forward emails"

  policy = data.aws_iam_policy_document.lambda.json
}

data "aws_iam_policy_document" "lambda" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "s3:GetObject",
      "ses:SendRawEmail"
    ]

    resources = [
      "${aws_s3_bucket.this.arn}/*",
      "${aws_ses_domain_identity.this.arn}/*"
    ]
  }
}
