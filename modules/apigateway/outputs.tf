output "api_id" {
  description = "API Gateway ID"
  value       = aws_apigatewayv2_api.this.id
}

output "api_endpoint" {
  description = "API Gateway endpoint"
  value       = aws_apigatewayv2_api.this.api_endpoint
}

output "api_arn" {
  description = "API Gateway ARN"
  value       = aws_apigatewayv2_api.this.arn
}

output "execution_arn" {
  description = "API Gateway execution ARN"
  value       = aws_apigatewayv2_api.this.execution_arn
}

output "stage_id" {
  description = "Stage ID"
  value       = aws_apigatewayv2_stage.this.id
}

output "authorizers" {
  description = "Map of authorizer IDs"
  value       = { for k, v in aws_apigatewayv2_authorizer.this : k => v.id }
}

output "custom_domain_target" {
  description = "Custom domain target"
  value       = try(aws_apigatewayv2_domain_name.this[0].domain_name_configuration[0].target_domain_name, null)
}
