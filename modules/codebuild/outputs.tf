output "project_id" {
  description = "The ID of the CodeBuild project"
  value       = aws_codebuild_project.this.id
}

output "project_name" {
  description = "The name of the CodeBuild project"
  value       = aws_codebuild_project.this.name
}

output "arn" {
  description = "The ARN of the CodeBuild project"
  value       = aws_codebuild_project.this.arn
}

output "badge_url" {
  description = "The URL of the build badge"
  value       = aws_codebuild_project.this.badge_url
}

output "log_group_name" {
  description = "The name of the CloudWatch log group"
  value       = var.create_log_group ? aws_cloudwatch_log_group.this[0].name : null
}

output "log_group_arn" {
  description = "The ARN of the CloudWatch log group"
  value       = var.create_log_group ? aws_cloudwatch_log_group.this[0].arn : null
}
