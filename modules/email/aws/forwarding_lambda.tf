data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/forwarding_lambda.py"
  output_path = "${path.module}/forwarding_lambda_payload.zip"
}

resource "aws_lambda_function" "forwarding_lambda" {
  filename      = "${path.module}/forwarding_lambda_payload.zip"
  function_name = "forwarding_lambda-${local.clean_domain}"
  role          = aws_iam_role.lambda.arn

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.8"
  handler = "lambda_handler"

  timeout = 30

  environment {
    variables = {
      MailS3Bucket = aws_s3_bucket.this.bucket
      MailS3Prefix = ""
      MailSender = aws_ses_email_identity.forwarding.email
      MailRecipient = var.forwarding_email_recipient
      Region = data.aws_region.current.name
    }
  }
  depends_on = [
    aws_cloudwatch_log_group.forwarding_lambda,
  ]
}

resource "aws_cloudwatch_log_group" "forwarding_lambda" {
  name              = "/aws/lambda/forwarding_lambda-${local.clean_domain}"
  retention_in_days = 7
}

resource "aws_lambda_permission" "allow_ses" {
  statement_id  = "GiveSESPermissionToInvokeFunction"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.forwarding_lambda.function_name
  principal     = "ses.amazonaws.com"
  source_arn    = "${aws_ses_receipt_rule_set.this.arn}:receipt-rule/store-to-s3"
}
