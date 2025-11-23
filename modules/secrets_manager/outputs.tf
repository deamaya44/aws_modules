# Secret Outputs
output "secret_id" {
  description = "The ID of the secret"
  value       = aws_secretsmanager_secret.this.id
}

output "secret_arn" {
  description = "The ARN of the secret"
  value       = aws_secretsmanager_secret.this.arn
}

output "secret_name" {
  description = "The name of the secret"
  value       = aws_secretsmanager_secret.this.name
}

output "secret_version_id" {
  description = "The unique identifier of the version of the secret"
  value       = try(aws_secretsmanager_secret_version.this[0].version_id, aws_secretsmanager_secret_version.binary[0].version_id, aws_secretsmanager_secret_version.generated_password[0].version_id, null)
}

# Generated Password Outputs (when applicable)
output "generated_password" {
  description = "The generated password (sensitive output)"
  value       = var.generate_random_password ? random_password.this[0].result : null
  sensitive   = true
}

output "generated_password_length" {
  description = "The length of the generated password"
  value       = var.generate_random_password ? random_password.this[0].length : null
}

# Rotation Configuration Outputs
output "rotation_enabled" {
  description = "Whether rotation is enabled for this secret"
  value       = var.enable_rotation
}

output "rotation_lambda_arn" {
  description = "The ARN of the Lambda function used for rotation"
  value       = var.enable_rotation ? var.rotation_lambda_arn : null
}