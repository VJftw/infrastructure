resource "aws_cloudtrail" "audit_csp" {
  provider       = aws
  name           = "audit-csp"
  s3_bucket_name = aws_s3_bucket.audit_csp.id

  include_global_service_events = true
  is_multi_region_trail         = true
  is_organization_trail         = false # we create a trail per account

  kms_key_id = aws_kms_alias.cloudtrail.arn

  enable_log_file_validation = true
  enable_logging             = true
}

resource "aws_kms_key" "cloudtrail" {
  provider = aws

  description             = "audit-csp in AWS CloudTrail"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

resource "aws_kms_alias" "cloudtrail" {
  provider = aws

  name          = "alias/cloudtrail-audit-csp"
  target_key_id = aws_kms_key.cloudtrail.key_id
}
