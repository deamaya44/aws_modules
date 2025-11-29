# Lambda Function
resource "aws_lambda_function" "this" {
  function_name = var.function_name
  role          = var.role_arn
  handler       = var.handler
  runtime       = var.runtime
  timeout       = var.timeout
  memory_size   = var.memory_size

  # Code deployment
  filename         = var.filename
  source_code_hash = var.filename != null ? filebase64sha256(var.filename) : null

  # S3 deployment (alternative to filename)
  s3_bucket         = var.s3_bucket
  s3_key            = var.s3_key
  s3_object_version = var.s3_object_version

  # Environment variables
  dynamic "environment" {
    for_each = var.environment_variables != null ? [1] : []
    content {
      variables = var.environment_variables
    }
  }

  # VPC Configuration
  dynamic "vpc_config" {
    for_each = var.subnet_ids != null && var.security_group_ids != null ? [1] : []
    content {
      subnet_ids         = var.subnet_ids
      security_group_ids = var.security_group_ids
    }
  }

  # Dead Letter Queue
  dynamic "dead_letter_config" {
    for_each = var.dead_letter_config_target_arn != null ? [1] : []
    content {
      target_arn = var.dead_letter_config_target_arn
    }
  }

  # Layers
  layers = var.layers

  # Publish version
  publish = var.publish

  # Reserved concurrent executions
  reserved_concurrent_executions = var.reserved_concurrent_executions

  tags = merge(
    var.common_tags,
    {
      Name = var.function_name
    }
  )
}

# Lambda Permission for API Gateway or other services
resource "aws_lambda_permission" "this" {
  count = var.create_api_gateway_permission ? 1 : 0

  statement_id  = var.permission_statement_id
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = var.permission_principal
  source_arn    = var.permission_source_arn
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "this" {
  count = var.create_log_group ? 1 : 0

  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.log_retention_days

  tags = merge(
    var.common_tags,
    {
      Name = "/aws/lambda/${var.function_name}"
    }
  )
}

# Lambda Function URL (optional)
resource "aws_lambda_function_url" "this" {
  count = var.create_function_url ? 1 : 0

  function_name      = aws_lambda_function.this.function_name
  authorization_type = var.function_url_auth_type

  dynamic "cors" {
    for_each = var.function_url_cors != null ? [1] : []
    content {
      allow_credentials = lookup(var.function_url_cors, "allow_credentials", false)
      allow_origins     = lookup(var.function_url_cors, "allow_origins", ["*"])
      allow_methods     = lookup(var.function_url_cors, "allow_methods", ["*"])
      allow_headers     = lookup(var.function_url_cors, "allow_headers", [])
      expose_headers    = lookup(var.function_url_cors, "expose_headers", [])
      max_age           = lookup(var.function_url_cors, "max_age", 0)
    }
  }
}
