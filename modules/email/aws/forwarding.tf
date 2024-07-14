resource "aws_ses_active_receipt_rule_set" "this" {
  rule_set_name = aws_ses_receipt_rule_set.this.rule_set_name
}

resource "aws_ses_receipt_rule_set" "this" {
  rule_set_name = "${var.domain}-rules"
}

resource "aws_ses_receipt_rule" "this" {
  name          = "store-to-s3"
  rule_set_name = aws_ses_receipt_rule_set.this.id
  enabled       = true
  scan_enabled  = true

  s3_action {
    bucket_name = aws_s3_bucket.this.bucket
    position    = 1
  }

  lambda_action {
    function_arn = aws_lambda_function.forwarding_lambda.arn
    position = 2
  }
  
  depends_on = [
    aws_lambda_permission.allow_ses,
    aws_s3_bucket_policy.ses_store_emails,
  ]
}

resource "aws_ses_email_identity" "forwarding" {
  email = "forwarding@${var.domain}"
}
