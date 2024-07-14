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

  runtime = "python3.7"
  handler = "lambda_handler"

  timeout = 30

  environment {
    variables = {
      MailS3Bucket = aws_s3_bucket.this.bucket
      MailS3Prefix = ""
      MailSender = "forwarding@${var.domain}"
      MailRecipient = var.forwarding_email_recipient
      Region = data.aws_region.current.name
    }
  }
}
