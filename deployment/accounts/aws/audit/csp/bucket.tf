locals {
  bucket_name = "${var.name}-audit-csp"
  bucket_arn  = "arn:aws:s3:::${local.bucket_name}"
}
resource "aws_s3_bucket" "audit_csp" {
  provider = aws.target

  bucket = local.bucket_name

  object_lock_enabled = true
}

resource "aws_s3_bucket_acl" "audit_csp" {
  provider = aws.target

  bucket = aws_s3_bucket.audit_csp.id
  acl    = "private"
}

// Object Lock
resource "aws_s3_bucket_object_lock_configuration" "audit_csp" {
  provider = aws.target

  bucket = aws_s3_bucket.audit_csp.id

  rule {
    default_retention {
      mode = "GOVERNANCE"
      days = 3
    }
  }
}

// SSE - Remove CMK to save cost
# resource "aws_kms_key" "bucket" {
#   provider = aws.target

#   description             = "This key is used to encrypt bucket objects"
#   deletion_window_in_days = 10

#   policy = data.aws_iam_policy_document.bucket_kms.json
# }

# resource "aws_kms_alias" "bucket" {
#   provider = aws.target

#   name          = "alias/${local.bucket_name}"
#   target_key_id = aws_kms_key.bucket.key_id
# }

data "aws_iam_policy_document" "bucket_kms" {
  statement {
    sid = "Allow local account"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.target.account_id}:root"]
    }

    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    sid = "Allow CloudTrail"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    effect = "Allow"

    actions = [
      "kms:GenerateDataKey*",
    ]

    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = [local.cloudtrail_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [local.cloudtrail_arn]
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "audit_csp" {
  provider = aws.target

  bucket = aws_s3_bucket.audit_csp.bucket

  rule {
    apply_server_side_encryption_by_default {
      # Don't use CMK key to save cost, use the default AWS
      # S3 master key instead.
      # kms_master_key_id = aws_kms_key.bucket.arn
      kms_master_key_id = "aws/s3"
      sse_algorithm     = "aws:kms"
    }
  }
}

// Lifecycle
resource "aws_s3_bucket_lifecycle_configuration" "audit_csp" {
  provider = aws.target

  bucket = aws_s3_bucket.audit_csp.bucket

  rule {
    id = "AuditExpireAfter14Days"

    expiration {
      days = 7
    }

    status = "Enabled"
  }
}

// Policy
resource "aws_s3_bucket_policy" "audit_csp" {
  provider = aws.target

  bucket = aws_s3_bucket.audit_csp.id
  policy = data.aws_iam_policy_document.audit_csp.json
}

data "aws_iam_policy_document" "audit_csp" {
  provider = aws.target

  statement {
    sid = "AWSCloudTrailAclCheck"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    effect = "Allow"

    actions = [
      "s3:GetBucketAcl",
    ]

    resources = [local.bucket_arn]
  }

  statement {
    sid = "AWSCloudTrailWrite"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    effect = "Allow"


    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${local.bucket_arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values = [
        local.cloudtrail_arn,
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }

  }

  statement {
    sid    = "TLSRequestsOnly"
    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = ["s3:*"]
    resources = [
      "${local.bucket_arn}/*"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_public_access_block" "audit_csp" {
  provider = aws.target

  bucket = aws_s3_bucket.audit_csp.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}
