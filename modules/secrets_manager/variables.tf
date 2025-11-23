# Basic Configuration
variable "secret_name" {
  description = "The name of the secret"
  type        = string
}

variable "description" {
  description = "A description of the secret"
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "The ARN or Id of the AWS KMS key to be used to encrypt the secret values"
  type        = string
  default     = null
}

variable "recovery_window_in_days" {
  description = "Number of days that AWS Secrets Manager waits before it can delete the secret"
  type        = number
  default     = 30
}

# Secret Content Options
variable "secret_string" {
  description = "The text data to encrypt and store in this version of the secret"
  type        = string
  default     = null
  sensitive   = true
}

variable "secret_key_value" {
  description = "Map of key-value pairs that will be JSON-encoded and stored as the secret string"
  type        = map(string)
  default     = null
  sensitive   = true
}

variable "secret_binary" {
  description = "The binary data to encrypt and store in this version of the secret"
  type        = string
  default     = null
  sensitive   = true
}

# Random Password Generation
variable "generate_random_password" {
  description = "Whether to generate a random password for the secret"
  type        = bool
  default     = false
}

variable "password_length" {
  description = "Length of the generated password"
  type        = number
  default     = 32
}

variable "password_include_special" {
  description = "Include special characters in generated password"
  type        = bool
  default     = true
}

variable "password_include_upper" {
  description = "Include uppercase letters in generated password"
  type        = bool
  default     = true
}

variable "password_include_lower" {
  description = "Include lowercase letters in generated password"
  type        = bool
  default     = true
}

variable "password_include_numeric" {
  description = "Include numbers in generated password"
  type        = bool
  default     = true
}

variable "username" {
  description = "Username to associate with the generated password"
  type        = string
  default     = "admin"
}

# Secret Rotation
variable "enable_rotation" {
  description = "Whether to enable automatic rotation for this secret"
  type        = bool
  default     = false
}

variable "rotation_lambda_arn" {
  description = "The ARN of the Lambda function that can rotate the secret"
  type        = string
  default     = null
}

variable "rotation_days" {
  description = "The number of days between automatic scheduled rotations of the secret"
  type        = number
  default     = 30
}

# Common Tags
variable "common_tags" {
  description = "A map of tags to assign to the secret"
  type        = map(string)
  default     = {}
}