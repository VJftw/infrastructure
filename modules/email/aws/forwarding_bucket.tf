resource "aws_s3_bucket" "this" {
  bucket = "${local.clean_domain}-emails"
}

resource "aws_s3_bucket_policy" "ses_store_emails" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.ses_store_emails.json
}

data "aws_iam_policy_document" "ses_store_emails" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["ses.amazonaws.com"]
    }

    actions = ["s3:PutObject"]

    resources = [
      "${aws_s3_bucket.this.arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:Referer"

      values = [data.aws_caller_identity.current.account_id]
    }
  }
}
