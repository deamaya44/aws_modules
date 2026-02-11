variable "pipeline_name" {
  description = "Name of the CodePipeline"
  type        = string
}

variable "role_arn" {
  description = "ARN of the IAM role for CodePipeline"
  type        = string
}

# Artifact Store Configuration
variable "artifact_store_location" {
  description = "S3 bucket for pipeline artifacts"
  type        = string
}

variable "artifact_store_type" {
  description = "Type of artifact store (S3)"
  type        = string
  default     = "S3"
}

variable "artifact_store_encryption_key_id" {
  description = "KMS key ID for artifact encryption"
  type        = string
  default     = null
}

variable "artifact_store_encryption_key_type" {
  description = "Type of encryption key (KMS)"
  type        = string
  default     = "KMS"
}

# Source Stage
variable "source_actions" {
  description = "List of source actions"
  type = list(object({
    name             = string
    owner            = string
    provider         = string
    version          = optional(string)
    output_artifacts = list(string)
    configuration    = map(string)
    run_order        = optional(number)
  }))
}

# Build Stage
variable "build_actions" {
  description = "List of build actions"
  type = list(object({
    name             = string
    input_artifacts  = list(string)
    output_artifacts = optional(list(string))
    configuration    = map(string)
    version          = optional(string)
    run_order        = optional(number)
  }))
  default = []
}

# Deploy Stage
variable "deploy_actions" {
  description = "List of deploy actions"
  type = list(object({
    name            = string
    owner           = optional(string)
    provider        = string
    input_artifacts = list(string)
    configuration   = map(string)
    version         = optional(string)
    run_order       = optional(number)
  }))
  default = []
}

# Approval Stage
variable "approval_actions" {
  description = "List of manual approval actions"
  type = list(object({
    name          = string
    configuration = optional(map(string))
    run_order     = optional(number)
  }))
  default = []
}

# Custom Stages
variable "custom_stages" {
  description = "List of custom stages"
  type = list(object({
    name = string
    actions = list(object({
      name             = string
      category         = string
      owner            = string
      provider         = string
      version          = optional(string)
      input_artifacts  = optional(list(string))
      output_artifacts = optional(list(string))
      configuration    = map(string)
      run_order        = optional(number)
    }))
  }))
  default = []
}

# EventBridge Configuration
variable "create_eventbridge_rule" {
  description = "Whether to create EventBridge rule for automatic triggers"
  type        = bool
  default     = false
}

variable "eventbridge_branch_names" {
  description = "List of branch names to trigger pipeline"
  type        = list(string)
  default     = ["main"]
}

variable "eventbridge_repository_arns" {
  description = "List of CodeCommit repository ARNs to monitor"
  type        = list(string)
  default     = []
}

variable "eventbridge_role_arn" {
  description = "IAM role ARN for EventBridge to invoke CodePipeline"
  type        = string
  default     = null
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
