resource "aws_cloudfront_origin_access_identity" "oai_frontend" {
  comment = "OAI for ${var.domain_name}"
}

data "aws_cloudfront_cache_policy" "disabled" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_origin_request_policy" "all" {
  name = "Managed-AllViewer"
}

resource "random_password" "alb_header_value" {
  length            = 40
  special           = true
  min_special       = 5
  override_special  = "!#$%^&*()-_=+[]{}<>:?"
  keepers           = {
    pass_version  = 1
  }
}


resource "aws_cloudfront_distribution" "cf_dist_frontend" {
  enabled             = true
  aliases             = [var.domain_name]
  default_root_object = "index.html"

  origin {
    domain_name = aws_s3_bucket.bucket_frontend.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.bucket_frontend.id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai_frontend.cloudfront_access_identity_path
    }
  }

  origin {
    domain_name = var.application_storage_bucket_domain_name
    origin_id   = var.application_storage_bucket_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai_frontend.cloudfront_access_identity_path
    }
  }

  origin {
    domain_name = var.alb_domain_name
    origin_id   = var.alb_domain_name

    custom_header {
      name  = "X-ALB-Header"
      value = random_password.alb_header_value.result
    }

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = aws_s3_bucket.bucket_frontend.id
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers      = []
      query_string = true

      cookies {
        forward = "all"
      }
    }
  }

  ordered_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = var.alb_domain_name
    viewer_protocol_policy = "redirect-to-https"

    path_pattern = "/api*"

    cache_policy_id = data.aws_cloudfront_cache_policy.disabled.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.all.id
  }

  ordered_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = var.application_storage_bucket_id
    viewer_protocol_policy = "redirect-to-https"

    path_pattern = "/storage/*"

    compress = true

    trusted_key_groups = [
      aws_cloudfront_key_group.object_signing_key_group.id
    ]

    forwarded_values {
      headers      = []
      query_string = true

      cookies {
        forward = "all"
      }
    }
  }

  http_version = "http2and3"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations = []
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.public_cert_frontend_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = {
    Name = "${var.namespace}_Frontend_Cloudfront_${var.environment}"
  }
}