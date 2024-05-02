data "aws_iam_policy_document" "this_origin" {
  statement {
    sid = "S3GetObjectForCloudFront"

    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.this.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

resource "aws_cloudfront_distribution" "this" {
  enabled = true

  aliases = [
    "mta-sts.${var.domain}",
  ]

  is_ipv6_enabled     = true
  comment             = ""
  default_root_object = "index.html"
  price_class         = "PriceClass_All"

  depends_on = [aws_s3_bucket.this]

  origin {
    origin_id   = "s3_website"
    domain_name = aws_s3_bucket_website_configuration.this.website_endpoint

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  default_cache_behavior {
    compress         = true
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "s3_website"

    viewer_protocol_policy = "redirect-to-https"

    cache_policy_id            = aws_cloudfront_cache_policy.this.id
    response_headers_policy_id = aws_cloudfront_response_headers_policy.this.id
  }

  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate.this.arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
    cloudfront_default_certificate = false
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

}

resource "aws_cloudfront_cache_policy" "this" {
  name        = "mta-sts"
  comment     = ""
  default_ttl = 60
  max_ttl     = 3600
  min_ttl     = 1
  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "none"
    }
  }
}

resource "aws_cloudfront_response_headers_policy" "this" {
  name = "mta-sts"

  security_headers_config {
    content_security_policy {
      override = true
      content_security_policy = "default-src 'none';"
    }

    content_type_options {
      override = true
    }

    frame_options {
      override     = true
      frame_option = "DENY"
    }

    referrer_policy {
      override        = true
      referrer_policy = "same-origin"
    }

    xss_protection {
      override   = true
      protection = true
      mode_block = true
    }
  }

}
