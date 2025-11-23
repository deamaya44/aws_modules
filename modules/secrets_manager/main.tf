# AWS Secrets Manager Secret
resource "aws_secretsmanager_secret" "this" {
  name                    = var.secret_name
  description            = var.description
  kms_key_id             = var.kms_key_id
  recovery_window_in_days = var.recovery_window_in_days
  
  tags = merge(
    var.common_tags,
    {
      Name = var.secret_name
    }
  )
}

# Secret Version with JSON value
resource "aws_secretsmanager_secret_version" "this" {
  count         = var.secret_string != null || var.secret_key_value != null ? 1 : 0
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = var.secret_string != null ? var.secret_string : jsonencode(var.secret_key_value)
}

# Secret Version with binary data
resource "aws_secretsmanager_secret_version" "binary" {
  count         = var.secret_binary != null ? 1 : 0
  secret_id     = aws_secretsmanager_secret.this.id
  secret_binary = var.secret_binary
}

# Optional: Random password generation
resource "random_password" "this" {
  count   = var.generate_random_password ? 1 : 0
  length  = var.password_length
  special = var.password_include_special
  upper   = var.password_include_upper
  lower   = var.password_include_lower
  numeric = var.password_include_numeric
}

# Secret Version with generated password
resource "aws_secretsmanager_secret_version" "generated_password" {
  count     = var.generate_random_password ? 1 : 0
  secret_id = aws_secretsmanager_secret.this.id
  secret_string = jsonencode({
    username = var.generated_password_username
    password = random_password.this[0].result
  })
}

# Optional: Secret rotation configuration
resource "aws_secretsmanager_secret_rotation" "this" {
  count           = var.enable_rotation ? 1 : 0
  secret_id       = aws_secretsmanager_secret.this.id
  rotation_lambda_arn = var.rotation_lambda_arn
  
  rotation_rules {
    automatically_after_days = var.rotation_days
  }
}