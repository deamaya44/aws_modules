variable "repository_name" {
  description = "Name of the CodeCommit repository"
  type        = string
}

variable "description" {
  description = "Description of the repository"
  type        = string
  default     = ""
}

variable "default_branch" {
  description = "Default branch name"
  type        = string
  default     = "main"
}

variable "create_trigger" {
  description = "Whether to create CodeCommit triggers"
  type        = bool
  default     = false
}

variable "triggers" {
  description = "List of triggers for the repository"
  type = list(object({
    name            = string
    destination_arn = string
    branches        = optional(list(string))
    events          = list(string)
  }))
  default = []
}

variable "create_approval_rule" {
  description = "Whether to create approval rule template"
  type        = bool
  default     = false
}

variable "approval_rule_description" {
  description = "Description for the approval rule template"
  type        = string
  default     = "Approval rule for pull requests"
}

variable "approval_rule_branches" {
  description = "List of branch references for approval rule"
  type        = list(string)
  default     = ["refs/heads/main"]
}

variable "approval_rule_approvals_needed" {
  description = "Number of approvals needed"
  type        = number
  default     = 1
}

variable "approval_rule_members" {
  description = "List of IAM ARNs that can approve"
  type        = list(string)
  default     = []
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
