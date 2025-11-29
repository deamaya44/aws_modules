variable "enabled" {
  description = "Whether the CloudFront distribution is enabled"
  type        = bool
  default     = true
}

variable "is_ipv6_enabled" {
  description = "Whether IPv6 is enabled for the distribution"
  type        = bool
  default     = true
}

variable "comment" {
  description = "Comment for the CloudFront distribution"
  type        = string
  default     = ""
}

variable "default_root_object" {
  description = "Object that CloudFront returns when a viewer requests the root URL"
  type        = string
  default     = "index.html"
}

variable "aliases" {
  description = "List of CNAME aliases for the distribution"
  type        = list(string)
  default     = []
}

variable "price_class" {
  description = "Price class for the distribution (PriceClass_All, PriceClass_200, PriceClass_100)"
  type        = string
  default     = "PriceClass_100"
}

variable "web_acl_id" {
  description = "AWS WAF web ACL ARN"
  type        = string
  default     = null
}

variable "create_oai" {
  description = "Whether to create Origin Access Identity"
  type        = bool
  default     = true
}

variable "oai_comment" {
  description = "Comment for the Origin Access Identity"
  type        = string
  default     = "OAI for S3 bucket access"
}

variable "origins" {
  description = "List of origins for the distribution"
  type        = list(any)
  default     = []
}

variable "default_cache_behavior" {
  description = "Default cache behavior configuration"
  type        = any
}

variable "ordered_cache_behaviors" {
  description = "List of ordered cache behaviors"
  type        = list(any)
  default     = []
}

variable "custom_error_responses" {
  description = "List of custom error responses"
  type        = list(any)
  default     = []
}

variable "viewer_certificate" {
  description = "Viewer certificate configuration"
  type        = any
  default = {
    cloudfront_default_certificate = true
  }
}

variable "geo_restriction" {
  description = "Geographic restrictions configuration"
  type        = any
  default = {
    restriction_type = "none"
  }
}

variable "logging_config" {
  description = "Logging configuration"
  type        = any
  default     = null
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
