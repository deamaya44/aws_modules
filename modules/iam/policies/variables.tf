# IAM Policy Configuration
variable "policy_name" {
  description = "Name of the IAM policy"
  type        = string
}

variable "description" {
  description = "Description of the IAM policy"
  type        = string
  default     = "IAM policy managed by Terraform"
}

variable "policy_document" {
  description = "JSON policy document"
  type        = string
}

variable "path" {
  description = "Path for the IAM policy"
  type        = string
  default     = "/"
}

# Attachments
variable "attach_to_roles" {
  description = "List of role names to attach this policy to"
  type        = list(string)
  default     = []
}

variable "attach_to_users" {
  description = "List of user names to attach this policy to"
  type        = list(string)
  default     = []
}

variable "attach_to_groups" {
  description = "List of group names to attach this policy to"
  type        = list(string)
  default     = []
}

# Common Tags
variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}