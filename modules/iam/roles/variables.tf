# IAM Role Configuration
variable "role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "description" {
  description = "Description of the IAM role"
  type        = string
  default     = "IAM role managed by Terraform"
}

variable "assume_role_policy" {
  description = "JSON policy document for the assume role policy"
  type        = string
}

variable "path" {
  description = "Path for the IAM role"
  type        = string
  default     = "/"
}

variable "max_session_duration" {
  description = "Maximum session duration (in seconds) for the role"
  type        = number
  default     = 3600
}

variable "permissions_boundary_arn" {
  description = "ARN of the permissions boundary policy"
  type        = string
  default     = null
}

# Policies
variable "aws_managed_policy_arns" {
  description = "List of AWS managed policy ARNs to attach to the role"
  type        = list(string)
  default     = []
}

variable "custom_policy_arns" {
  description = "List of custom policy ARNs to attach to the role"
  type        = list(string)
  default     = []
}

variable "inline_policies" {
  description = "List of inline policies to attach to the role"
  type = list(object({
    name   = string
    policy = string
  }))
  default = []
}

# Instance Profile
variable "create_instance_profile" {
  description = "Whether to create an instance profile for EC2 use"
  type        = bool
  default     = false
}

# Common Tags
variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}