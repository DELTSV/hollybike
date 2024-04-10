resource "aws_cloudfront_origin_access_identity" "oai_frontend" {
  comment = "OAI for ${var.domain_name}"
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

  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
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

  http_version = "http2and3"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["FR"]
    }
  }

  tags = {
    "Project"   = var.domain_name
    "ManagedBy" = "Terraform"
  }

  viewer_certificate {
    acm_certificate_arn      = var.public-cert-frontend-arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

#   depends_on = [aws_acm_certificate_validation.frontend]
}