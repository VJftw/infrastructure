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
}
