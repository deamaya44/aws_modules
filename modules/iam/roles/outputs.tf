# IAM Role Outputs
output "role_arn" {
    description = "The ARN of the IAM role"
    value       = aws_iam_role.this.arn
}

output "role_name" {
    description = "The name of the IAM role"
    value       = aws_iam_role.this.name
}

output "role_id" {
    description = "The ID of the IAM role"
    value       = aws_iam_role.this.id
}

output "role_unique_id" {
    description = "The unique ID of the IAM role"
    value       = aws_iam_role.this.unique_id
}

output "role_create_date" {
    description = "The creation date of the IAM role"
    value       = aws_iam_role.this.create_date
}

output "instance_profile_arn" {
    description = "The ARN of the instance profile (if created)"
    value       = var.create_instance_profile ? aws_iam_instance_profile.this[0].arn : null
}

output "instance_profile_name" {
    description = "The name of the instance profile (if created)"
    value       = var.create_instance_profile ? aws_iam_instance_profile.this[0].name : null
}

output "attached_aws_policies" {
    description = "List of attached AWS managed policies"
    value       = aws_iam_role_policy_attachment.aws_managed[*].policy_arn
}

output "attached_custom_policies" {
    description = "List of attached custom policies"
    value       = aws_iam_role_policy_attachment.custom[*].policy_arn
}