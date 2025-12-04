# CloudFront Module

This module creates an AWS CloudFront distribution with support for multiple origins, custom cache behaviors, and S3 origin access identity.

## Features

- CloudFront distribution creation
- Origin Access Identity (OAI) for S3
- Multiple origins support
- Custom cache behaviors
- Custom error responses
- SSL/TLS configuration
- Geographic restrictions
- Access logging

## Usage

```hcl
module "cloudfront" {
  source = "./modules/cloudfront"

  comment             = "My CloudFront Distribution"
  default_root_object = "index.html"
  price_class         = "PriceClass_100"

  origins = [
    {
      domain_name = "my-bucket.s3.us-east-1.amazonaws.com"
      origin_id   = "S3-my-bucket"
      s3_origin_config = {}
    }
  ]

  default_cache_behavior = {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-my-bucket"

    forwarded_values = {
      query_string = false
      cookies = {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
  }

  custom_error_responses = [
    {
      error_code         = 404
      response_code      = 200
      response_page_path = "/index.html"
    }
  ]

  common_tags = {
    Environment = "dev"
    Project     = "my-project"
  }
}
```

## Variables

See `variables.tf` for all available variables.

## Outputs

See `outputs.tf` for all available outputs.
