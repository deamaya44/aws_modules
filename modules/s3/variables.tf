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