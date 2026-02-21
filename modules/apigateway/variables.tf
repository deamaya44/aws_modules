variable "api_name" {
  description = "Name of the API Gateway"
  type        = string
}

variable "protocol_type" {
  description = "Protocol type (HTTP or WEBSOCKET)"
  type        = string
  default     = "HTTP"
}

variable "stage_name" {
  description = "Stage name"
  type        = string
  default     = "$default"
}

variable "auto_deploy" {
  description = "Auto deploy stage"
  type        = bool
  default     = true
}

variable "cors_configuration" {
  description = "CORS configuration"
  type = object({
    allow_origins     = list(string)
    allow_methods     = list(string)
    allow_headers     = list(string)
    expose_headers    = optional(list(string))
    max_age           = optional(number)
    allow_credentials = optional(bool)
  })
  default = null
}

variable "throttling_burst_limit" {
  description = "Throttling burst limit"
  type        = number
  default     = null
}

variable "throttling_rate_limit" {
  description = "Throttling rate limit"
  type        = number
  default     = null
}

variable "integrations" {
  description = "Map of integrations"
  type = map(object({
    integration_type       = string
    integration_uri        = string
    integration_method     = optional(string)
    payload_format_version = optional(string)
  }))
  default = {}
}

variable "routes" {
  description = "Map of routes"
  type = map(object({
    route_key          = string
    integration_key    = string
    authorization_type = optional(string)
    authorizer_id      = optional(string)
  }))
  default = {}
}

variable "authorizers" {
  description = "Map of authorizers"
  type = map(object({
    authorizer_type         = string
    authorizer_uri          = string
    identity_sources        = list(string)
    name                    = string
    payload_format_version  = optional(string)
    enable_simple_responses = optional(bool)
  }))
  default = {}
}

variable "custom_domain_name" {
  description = "Custom domain name"
  type        = string
  default     = null
}

variable "certificate_arn" {
  description = "ACM certificate ARN"
  type        = string
  default     = null
}

variable "endpoint_type" {
  description = "Endpoint type (REGIONAL or EDGE)"
  type        = string
  default     = "REGIONAL"
}

variable "security_policy" {
  description = "Security policy"
  type        = string
  default     = "TLS_1_2"
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
