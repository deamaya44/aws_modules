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
