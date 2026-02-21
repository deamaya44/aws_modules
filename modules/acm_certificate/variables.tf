variable "domain_name" {
  description = "Domain name for the certificate"
  type        = string
}

variable "validation_method" {
  description = "Validation method (DNS or EMAIL)"
  type        = string
  default     = "DNS"
}

variable "subject_alternative_names" {
  description = "Subject alternative names"
  type        = list(string)
  default     = []
}

variable "wait_for_validation" {
  description = "Wait for certificate validation"
  type        = bool
  default     = false
}

variable "validation_record_fqdns" {
  description = "Validation record FQDNs"
  type        = list(string)
  default     = []
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
