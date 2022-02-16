resource "aws_s3_bucket" "audit_csp" {
  provider = aws.logs

  bucket = "${var.name}-audit-csp"

  object_lock_configuration {
    object_lock_enabled = "Enabled"
  }

}

resource "aws_s3_bucket_acl" "audit_csp" {
  provider = aws.logs

  bucket = aws_s3_bucket.audit_csp.id
  acl    = "private"
}

// Object Lock
resource "aws_s3_bucket_object_lock_configuration" "audit_csp" {
  provider = aws.logs

  bucket = aws_s3_bucket.audit_csp.id

  rule {
    default_retention {
      mode = "GOVERNANCE"
      days = 5
    }
  }
}

// SSE
resource "aws_kms_key" "bucket" {
  provider = aws.logs

  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "audit_csp" {
  provider = aws.logs

  bucket = aws_s3_bucket.audit_csp.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.bucket.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

// Lifecycle
resource "aws_s3_bucket_lifecycle_configuration" "audit_csp" {
  provider = aws.logs

  bucket = aws_s3_bucket.audit_csp.bucket

  rule {
    id = "AuditExpireAfter14Days"

    expiration {
      days = 14
    }

    status = "Enabled"

    transition {
      days          = 3
      storage_class = "STANDARD_IA"
    }
  }
}

// Policy
resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  provider = aws.logs

  bucket = aws_s3_bucket.audit_csp.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  provider = aws.logs

  statement {
    sid = "AWSCloudTrailAclCheck20131101"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl",
    ]

    resources = [aws_s3_bucket.audit_csp.arn]
  }

  statement {
    sid = "AWSCloudTrailWrite20131101"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.audit_csp.bucket}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [aws_cloudtrail.audit_csp.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }

  }
}
