locals {
  cloudtrail_name = "audit-csp"
  cloudtrail_arn  = "arn:aws:cloudtrail:${data.aws_region.source.name}:${data.aws_caller_identity.source.account_id}:trail/${local.cloudtrail_name}"
}
resource "aws_cloudtrail" "audit_csp" {
  provider       = aws
  name           = local.cloudtrail_name
  s3_bucket_name = aws_s3_bucket.audit_csp.id

  include_global_service_events = true
  is_multi_region_trail         = true
  is_organization_trail         = false # we create a trail per account

  kms_key_id = aws_kms_alias.cloudtrail.arn

  enable_log_file_validation = true
  enable_logging             = true

  depends_on = [
    aws_s3_bucket_policy.csp_audit,
  ]
}

resource "aws_kms_key" "cloudtrail" {
  provider = aws

  description             = "audit-csp in AWS CloudTrail"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  policy = data.aws_iam_policy_document.cloudtrail_kms.json
}

resource "aws_kms_alias" "cloudtrail" {
  provider = aws

  name          = "alias/cloudtrail-audit-csp"
  target_key_id = aws_kms_key.cloudtrail.key_id
}

data "aws_iam_policy_document" "cloudtrail_kms" {
  statement {
    sid = "Allow local account"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.source.account_id}:root"]
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
      values = [
        local.cloudtrail_arn,
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [local.cloudtrail_arn]
    }
  }
}
