variable "name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "policy" {
  description = "S3 bucket policy JSON document"
  type        = string
  default     = null
}

variable "versioning" {
  description = "Enable versioning on the S3 bucket"
  type        = bool
  default     = false
}

variable "block_public_access" {
  description = "Enable S3 bucket public access block"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to the S3 bucket"
  type        = map(string)
  default     = {}
}

# Cross-Region Replication Variables
variable "enable_crr" {
  description = "Enable Cross-Region Replication for the S3 bucket"
  type        = bool
  default     = false
}

variable "crr_role_arn" {
  description = "ARN of the IAM role for Cross-Region Replication (must be created externally)"
  type        = string
  default     = null
}

variable "crr_destination_bucket" {
  description = "Destination bucket ARN for Cross-Region Replication"
  type        = string
  default     = null
}

variable "crr_destination_storage_class" {
  description = "Storage class for replicated objects"
  type        = string
  default     = "STANDARD_IA"
  validation {
    condition = contains([
      "STANDARD", "REDUCED_REDUNDANCY", "STANDARD_IA", "ONEZONE_IA",
      "INTELLIGENT_TIERING", "GLACIER", "DEEP_ARCHIVE", "GLACIER_IR"
    ], var.crr_destination_storage_class)
    error_message = "Storage class must be a valid S3 storage class."
  }
}

variable "crr_prefix" {
  description = "Object key prefix for replication rule"
  type        = string
  default     = ""
}

variable "crr_delete_marker_replication" {
  description = "Whether to replicate delete markers"
  type        = bool
  default     = false
}

# Encryption Variables
variable "enable_server_side_encryption" {
  description = "Enable server-side encryption for the S3 bucket"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "KMS key ID for server-side encryption (if not provided, uses S3 managed keys)"
  type        = string
  default     = null
}

# Lifecycle Configuration
variable "lifecycle_rules" {
  description = "List of lifecycle rules"
  type = list(object({
    id                                     = string
    enabled                                = bool
    abort_incomplete_multipart_upload_days = optional(number)
    expiration = optional(object({
      days                         = optional(number)
      date                         = optional(string)
      expired_object_delete_marker = optional(bool)
    }))
    noncurrent_version_expiration = optional(object({
      noncurrent_days = number
    }))
    transition = optional(list(object({
      days          = optional(number)
      date          = optional(string)
      storage_class = string
    })))
    noncurrent_version_transition = optional(list(object({
      noncurrent_days = number
      storage_class   = string
    })))
    filter = optional(object({
      prefix                   = optional(string)
      object_size_greater_than = optional(number)
      object_size_less_than    = optional(number)
      tags                     = optional(map(string))
    }))
  }))
  default = []
}