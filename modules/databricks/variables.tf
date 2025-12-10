# Databricks Account Configuration
variable "databricks_account_id" {
  description = "Databricks Account ID"
  type        = string
}

variable "workspace_name" {
  description = "Name for the Databricks workspace"
  type        = string
}

variable "deployment_name" {
  description = "Databricks deployment name (must be unique globally) - DEPRECATED: This parameter is no longer used and will be ignored"
  type        = string
  default     = null
}

variable "aws_region" {
  description = "AWS region where the workspace will be deployed"
  type        = string
  default     = "us-east-1"
}

# IAM Configuration (external roles)
variable "cross_account_role_arn" {
  description = "ARN of the cross-account IAM role for Databricks"
  type        = string
}

# Storage Configuration (bucket created externally)
variable "databricks_root_bucket_name" {
  description = "Name of the S3 bucket for Databricks root storage (DBFS) - must be created externally"
  type        = string
}

# Network Configuration (Optional)
variable "vpc_id" {
  description = "VPC ID where Databricks will be deployed (optional for customer-managed VPC)"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "List of subnet IDs for Databricks deployment (required if vpc_id is provided)"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "List of security group IDs for Databricks clusters (optional)"
  type        = list(string)
  default     = []
}

# Encryption Configuration (Optional)
variable "customer_managed_key_id" {
  description = "AWS KMS key ARN for customer-managed encryption (optional)"
  type        = string
  default     = null
}

variable "customer_managed_key_alias" {
  description = "AWS KMS key alias for customer-managed encryption (optional)"
  type        = string
  default     = null
}

# Unity Catalog Configuration (Optional)
variable "unity_catalog_bucket_name" {
  description = "S3 bucket name for Unity Catalog metastore (optional)"
  type        = string
  default     = null
}

variable "unity_catalog_iam_role_arn" {
  description = "IAM role ARN for Unity Catalog access (optional)"
  type        = string
  default     = null
}

# Common Tags
variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# Workspace Configuration
variable "enable_ip_access_lists" {
  description = "Enable IP access lists for the workspace"
  type        = bool
  default     = false
}

variable "allowed_ip_addresses" {
  description = "List of allowed IP addresses/CIDR blocks"
  type        = list(string)
  default     = []
}

# External Locations Configuration
variable "storage_credentials" {
  description = "Map of storage credentials to create in Databricks"
  type = map(object({
    name          = string
    iam_role_arn  = string
    comment       = optional(string, "Managed by Terraform")
    owner         = optional(string)
    force_destroy = optional(bool, false)
    read_only     = optional(bool, false)
  }))
  default = {}
}

variable "external_locations" {
  description = "Map of external locations to create in Databricks"
  type = map(object({
    name            = string
    url             = string
    credential_key  = string # Key reference to storage_credentials map
    comment         = optional(string, "Managed by Terraform")
    owner           = optional(string)
    force_destroy   = optional(bool, false)
    read_only       = optional(bool, false)
    skip_validation = optional(bool, false)
    grants = optional(list(object({
      principal  = string
      privileges = list(string)
    })))
  }))
  default = {}
}
