output "function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.this.function_name
}

output "function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.this.arn
}

output "function_qualified_arn" {
  description = "Qualified ARN of the Lambda function"
  value       = aws_lambda_function.this.qualified_arn
}

output "function_invoke_arn" {
  description = "Invoke ARN of the Lambda function"
  value       = aws_lambda_function.this.invoke_arn
}

output "function_version" {
  description = "Version of the Lambda function"
  value       = aws_lambda_function.this.version
}

output "function_url" {
  description = "URL of the Lambda function (if created)"
  value       = var.create_function_url ? aws_lambda_function_url.this[0].function_url : null
}

output "log_group_name" {
  description = "Name of the CloudWatch Log Group"
  value       = var.create_log_group ? aws_cloudwatch_log_group.this[0].name : null
}
