resource "aws_cloudfront_distribution" "website" {
  enabled = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases = [var.cloudfront_config.custom_domain]
  price_class = var.cloudfront_config.price_class
  origin {
    domain_name = var.cloudfront_config.regional_bucket_domain_name
    origin_id = "S3-${var.cloudfront_config.bucket_name}"

    s3_origin_config {
      origin_access_identity = var.cloudfront_config.origin_access_identity_path
    }
  }

# Handle SPA routing
  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  default_cache_behavior {
    allowed_methods  = [ "GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${var.cloudfront_config.bucket_name}"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress = true
  }
    restrictions {
      geo_restriction {
      restriction_type = "none"
      }
    }
    viewer_certificate {
        acm_certificate_arn = var.cloudfront_config.acm_certificate_arn
        minimum_protocol_version = "TLSv1.2_2021"
        ssl_support_method = "sni-only"
    }
}