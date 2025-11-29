variable "name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the S3 bucket"
  type        = map(string)
  default     = {}
}

variable "policy" {
  description = "The bucket policy to apply to the S3 bucket"
  type        = string
  default     = null
}

variable "versioning" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = false
}

variable "block_public_access" {
  description = "Enable public access block for the S3 bucket"
  type        = bool
  default     = true
}
variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error"
  type        = bool
  default     = false
}
variable "acl" {
  description = "The canned ACL to apply. Defaults to 'private'"
  type        = string
  default     = "private"
}
variable "acl_enabled" {
  description = "Whether to enable ACL configuration"
  type        = bool
  default     = false
}
variable "replication_enabled" {
  description = "Enable replication configuration for the S3 bucket"
  type        = bool
  default     = false
}
variable "role_arn" {
  description = "The ARN of the IAM role for replication"
  type        = string
  default     = null
}
variable "bucket_id" {
  description = "The ID of the source bucket for replication"
  type        = string  
  default     = null
}
variable "destination_bucket_arn" {
  description = "The ARN of the destination bucket for replication"
  type        = string  
  default     = null
}
variable "storage_class" {
  description = "The storage class for replicated objects"
  type        = string  
  default     = "STANDARD"
}