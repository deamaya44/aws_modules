variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "role_arn" {
  description = "IAM role ARN for the Lambda function"
  type        = string
}

variable "handler" {
  description = "Lambda function handler"
  type        = string
  default     = "index.handler"
}

variable "runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "python3.11"
}

variable "timeout" {
  description = "Lambda function timeout in seconds"
  type        = number
  default     = 30
}

variable "memory_size" {
  description = "Lambda function memory size in MB"
  type        = number
  default     = 256
}

variable "filename" {
  description = "Path to the Lambda deployment package (zip file)"
  type        = string
  default     = null
}

variable "s3_bucket" {
  description = "S3 bucket containing Lambda deployment package"
  type        = string
  default     = null
}

variable "s3_key" {
  description = "S3 key of Lambda deployment package"
  type        = string
  default     = null
}

variable "s3_object_version" {
  description = "S3 object version of Lambda deployment package"
  type        = string
  default     = null
}

variable "environment_variables" {
  description = "Environment variables for Lambda function"
  type        = map(string)
  default     = null
}

variable "subnet_ids" {
  description = "Subnet IDs for Lambda VPC configuration"
  type        = list(string)
  default     = null
}

variable "security_group_ids" {
  description = "Security group IDs for Lambda VPC configuration"
  type        = list(string)
  default     = null
}

variable "dead_letter_config_target_arn" {
  description = "ARN of SQS queue or SNS topic for dead letter queue"
  type        = string
  default     = null
}

variable "layers" {
  description = "List of Lambda layer ARNs"
  type        = list(string)
  default     = []
}

variable "publish" {
  description = "Whether to publish a new version of the Lambda function"
  type        = bool
  default     = false
}

variable "reserved_concurrent_executions" {
  description = "Reserved concurrent executions for the Lambda function"
  type        = number
  default     = -1
}

variable "create_api_gateway_permission" {
  description = "Whether to create API Gateway permission for Lambda"
  type        = bool
  default     = false
}

variable "permission_statement_id" {
  description = "Statement ID for Lambda permission"
  type        = string
  default     = "AllowAPIGatewayInvoke"
}

variable "permission_principal" {
  description = "Principal for Lambda permission"
  type        = string
  default     = "apigateway.amazonaws.com"
}

variable "permission_source_arn" {
  description = "Source ARN for Lambda permission"
  type        = string
  default     = null
}

variable "create_log_group" {
  description = "Whether to create CloudWatch Log Group"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "CloudWatch Log Group retention in days"
  type        = number
  default     = 7
}

variable "create_function_url" {
  description = "Whether to create Lambda function URL"
  type        = bool
  default     = false
}

variable "function_url_auth_type" {
  description = "Authorization type for Lambda function URL (NONE or AWS_IAM)"
  type        = string
  default     = "NONE"
}

variable "function_url_cors" {
  description = "CORS configuration for Lambda function URL"
  type        = map(any)
  default     = null
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
