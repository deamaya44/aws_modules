# IAM Policy Outputs
output "policy_arn" {
  description = "The ARN of the IAM policy"
  value       = aws_iam_policy.this.arn
}

output "policy_name" {
  description = "The name of the IAM policy"
  value       = aws_iam_policy.this.name
}

output "policy_id" {
  description = "The ID of the IAM policy"
  value       = aws_iam_policy.this.id
}

output "policy_path" {
  description = "The path of the IAM policy"
  value       = aws_iam_policy.this.path
}

output "policy_attachment_count" {
  description = "Total number of attachments made"
  value       = length(var.attach_to_roles) + length(var.attach_to_users) + length(var.attach_to_groups)
}

output "attached_roles" {
  description = "List of roles this policy is attached to"
  value       = var.attach_to_roles
}

output "attached_users" {
  description = "List of users this policy is attached to"
  value       = var.attach_to_users
}

output "attached_groups" {
  description = "List of groups this policy is attached to"
  value       = var.attach_to_groups
}