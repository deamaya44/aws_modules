# CloudFront Origin Access Identity (for S3)
resource "aws_cloudfront_origin_access_identity" "this" {
  count = var.create_oai ? 1 : 0

  comment = var.oai_comment

  lifecycle {
    create_before_destroy = true
  }
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "this" {
  enabled             = var.enabled
  is_ipv6_enabled     = var.is_ipv6_enabled
  comment             = var.comment
  default_root_object = var.default_root_object
  aliases             = var.aliases
  price_class         = var.price_class
  web_acl_id          = var.web_acl_id

  # Origin configuration
  dynamic "origin" {
    for_each = var.origins
    content {
      domain_name = origin.value.domain_name
      origin_id   = origin.value.origin_id
      origin_path = lookup(origin.value, "origin_path", "")

      # S3 Origin with OAI
      dynamic "s3_origin_config" {
        for_each = lookup(origin.value, "s3_origin_config", null) != null ? [1] : []
        content {
          origin_access_identity = var.create_oai ? aws_cloudfront_origin_access_identity.this[0].cloudfront_access_identity_path : lookup(origin.value.s3_origin_config, "origin_access_identity", "")
        }
      }

      # Custom Origin
      dynamic "custom_origin_config" {
        for_each = lookup(origin.value, "custom_origin_config", null) != null ? [1] : []
        content {
          http_port              = lookup(origin.value.custom_origin_config, "http_port", 80)
          https_port             = lookup(origin.value.custom_origin_config, "https_port", 443)
          origin_protocol_policy = lookup(origin.value.custom_origin_config, "origin_protocol_policy", "https-only")
          origin_ssl_protocols   = lookup(origin.value.custom_origin_config, "origin_ssl_protocols", ["TLSv1.2"])
        }
      }

      # Custom Headers
      dynamic "custom_header" {
        for_each = lookup(origin.value, "custom_headers", [])
        content {
          name  = custom_header.value.name
          value = custom_header.value.value
        }
      }
    }
  }

  # Default Cache Behavior
  default_cache_behavior {
    allowed_methods  = var.default_cache_behavior.allowed_methods
    cached_methods   = var.default_cache_behavior.cached_methods
    target_origin_id = var.default_cache_behavior.target_origin_id

    forwarded_values {
      query_string = lookup(var.default_cache_behavior.forwarded_values, "query_string", false)
      headers      = lookup(var.default_cache_behavior.forwarded_values, "headers", [])

      cookies {
        forward = lookup(var.default_cache_behavior.forwarded_values.cookies, "forward", "none")
      }
    }

    viewer_protocol_policy = lookup(var.default_cache_behavior, "viewer_protocol_policy", "redirect-to-https")
    min_ttl                = lookup(var.default_cache_behavior, "min_ttl", 0)
    default_ttl            = lookup(var.default_cache_behavior, "default_ttl", 3600)
    max_ttl                = lookup(var.default_cache_behavior, "max_ttl", 86400)
    compress               = lookup(var.default_cache_behavior, "compress", true)

    # Lambda@Edge functions
    dynamic "lambda_function_association" {
      for_each = lookup(var.default_cache_behavior, "lambda_function_associations", [])
      content {
        event_type   = lambda_function_association.value.event_type
        lambda_arn   = lambda_function_association.value.lambda_arn
        include_body = lookup(lambda_function_association.value, "include_body", false)
      }
    }
  }

  # Additional Cache Behaviors
  dynamic "ordered_cache_behavior" {
    for_each = var.ordered_cache_behaviors
    content {
      path_pattern     = ordered_cache_behavior.value.path_pattern
      allowed_methods  = ordered_cache_behavior.value.allowed_methods
      cached_methods   = ordered_cache_behavior.value.cached_methods
      target_origin_id = ordered_cache_behavior.value.target_origin_id

      forwarded_values {
        query_string = lookup(ordered_cache_behavior.value.forwarded_values, "query_string", false)
        headers      = lookup(ordered_cache_behavior.value.forwarded_values, "headers", [])

        cookies {
          forward = lookup(ordered_cache_behavior.value.forwarded_values.cookies, "forward", "none")
        }
      }

      viewer_protocol_policy = lookup(ordered_cache_behavior.value, "viewer_protocol_policy", "redirect-to-https")
      min_ttl                = lookup(ordered_cache_behavior.value, "min_ttl", 0)
      default_ttl            = lookup(ordered_cache_behavior.value, "default_ttl", 3600)
      max_ttl                = lookup(ordered_cache_behavior.value, "max_ttl", 86400)
      compress               = lookup(ordered_cache_behavior.value, "compress", true)
    }
  }

  # Custom Error Responses
  dynamic "custom_error_response" {
    for_each = var.custom_error_responses
    content {
      error_code            = custom_error_response.value.error_code
      response_code         = lookup(custom_error_response.value, "response_code", null)
      response_page_path    = lookup(custom_error_response.value, "response_page_path", null)
      error_caching_min_ttl = lookup(custom_error_response.value, "error_caching_min_ttl", 10)
    }
  }

  # Viewer Certificate
  viewer_certificate {
    cloudfront_default_certificate = var.viewer_certificate.cloudfront_default_certificate
    acm_certificate_arn            = lookup(var.viewer_certificate, "acm_certificate_arn", null)
    ssl_support_method             = lookup(var.viewer_certificate, "ssl_support_method", null)
    minimum_protocol_version       = lookup(var.viewer_certificate, "minimum_protocol_version", "TLSv1.2_2021")
  }

  # Restrictions
  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction.restriction_type
      locations        = lookup(var.geo_restriction, "locations", [])
    }
  }

  # Logging
  dynamic "logging_config" {
    for_each = var.logging_config != null ? [1] : []
    content {
      bucket          = var.logging_config.bucket
      prefix          = lookup(var.logging_config, "prefix", "")
      include_cookies = lookup(var.logging_config, "include_cookies", false)
    }
  }

  tags = merge(
    var.common_tags,
    {
      Name = var.comment
    }
  )
}
