variable "project_name" {
  description = "Name of the CodeBuild project"
  type        = string
}

variable "description" {
  description = "Description of the CodeBuild project"
  type        = string
  default     = ""
}

variable "service_role_arn" {
  description = "ARN of the IAM role for CodeBuild"
  type        = string
}

variable "build_timeout" {
  description = "Build timeout in minutes"
  type        = number
  default     = 60
}

# Artifacts Configuration
variable "artifacts_type" {
  description = "Type of artifacts (CODEPIPELINE, S3, NO_ARTIFACTS)"
  type        = string
  default     = "CODEPIPELINE"
}

variable "artifacts_location" {
  description = "S3 bucket name for artifacts"
  type        = string
  default     = null
}

variable "artifacts_name" {
  description = "Name of the artifact"
  type        = string
  default     = null
}

variable "artifacts_namespace_type" {
  description = "Namespace type (NONE, BUILD_ID)"
  type        = string
  default     = null
}

variable "artifacts_packaging" {
  description = "Packaging type (NONE, ZIP)"
  type        = string
  default     = null
}

variable "artifacts_encryption_disabled" {
  description = "Whether to disable encryption for artifacts"
  type        = bool
  default     = false
}

variable "artifacts_override_name" {
  description = "Whether to override artifact name"
  type        = bool
  default     = false
}

# Environment Configuration
variable "compute_type" {
  description = "Compute type (BUILD_GENERAL1_SMALL, BUILD_GENERAL1_MEDIUM, BUILD_GENERAL1_LARGE)"
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}

variable "image" {
  description = "Docker image to use"
  type        = string
  default     = "aws/codebuild/standard:7.0"
}

variable "environment_type" {
  description = "Environment type (LINUX_CONTAINER, WINDOWS_CONTAINER, ARM_CONTAINER)"
  type        = string
  default     = "LINUX_CONTAINER"
}

variable "image_pull_credentials_type" {
  description = "Credentials type (CODEBUILD, SERVICE_ROLE)"
  type        = string
  default     = "CODEBUILD"
}

variable "privileged_mode" {
  description = "Whether to enable privileged mode (required for Docker)"
  type        = bool
  default     = false
}

variable "environment_variables" {
  description = "List of environment variables"
  type = list(object({
    name  = string
    value = string
    type  = optional(string)
  }))
  default = []
}

# Source Configuration
variable "source_type" {
  description = "Source type (CODECOMMIT, CODEPIPELINE, GITHUB, S3)"
  type        = string
  default     = "CODEPIPELINE"
}

variable "source_location" {
  description = "Source location (repository URL or S3 path)"
  type        = string
  default     = null
}

variable "buildspec" {
  description = "Buildspec file path or inline buildspec"
  type        = string
  default     = "buildspec.yml"
}

variable "git_clone_depth" {
  description = "Git clone depth"
  type        = number
  default     = 1
}

variable "fetch_git_submodules" {
  description = "Whether to fetch git submodules"
  type        = bool
  default     = false
}

# VPC Configuration
variable "vpc_id" {
  description = "VPC ID for CodeBuild"
  type        = string
  default     = null
}

variable "subnets" {
  description = "List of subnet IDs"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
  default     = []
}

# Cache Configuration
variable "cache_type" {
  description = "Cache type (NO_CACHE, S3, LOCAL)"
  type        = string
  default     = null
}

variable "cache_location" {
  description = "S3 bucket for cache"
  type        = string
  default     = null
}

variable "cache_modes" {
  description = "Cache modes for LOCAL cache"
  type        = list(string)
  default     = []
}

# Logs Configuration
variable "cloudwatch_logs_status" {
  description = "CloudWatch logs status (ENABLED, DISABLED)"
  type        = string
  default     = "ENABLED"
}

variable "cloudwatch_logs_group_name" {
  description = "CloudWatch log group name"
  type        = string
  default     = null
}

variable "cloudwatch_logs_stream_name" {
  description = "CloudWatch log stream name"
  type        = string
  default     = null
}

variable "s3_logs_status" {
  description = "S3 logs status (ENABLED, DISABLED)"
  type        = string
  default     = null
}

variable "s3_logs_location" {
  description = "S3 location for logs"
  type        = string
  default     = null
}

variable "s3_logs_encryption_disabled" {
  description = "Whether to disable S3 logs encryption"
  type        = bool
  default     = false
}

variable "create_log_group" {
  description = "Whether to create CloudWatch log group"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 7
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
