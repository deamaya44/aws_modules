output "pipeline_id" {
  description = "The ID of the CodePipeline"
  value       = aws_codepipeline.this.id
}

output "pipeline_name" {
  description = "The name of the CodePipeline"
  value       = aws_codepipeline.this.name
}

output "arn" {
  description = "The ARN of the CodePipeline"
  value       = aws_codepipeline.this.arn
}

output "eventbridge_rule_arn" {
  description = "The ARN of the EventBridge rule"
  value       = var.create_eventbridge_rule ? aws_cloudwatch_event_rule.this[0].arn : null
}

output "eventbridge_rule_name" {
  description = "The name of the EventBridge rule"
  value       = var.create_eventbridge_rule ? aws_cloudwatch_event_rule.this[0].name : null
}
