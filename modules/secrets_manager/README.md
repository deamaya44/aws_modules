# AWS Secrets Manager Module

This module creates and manages AWS Secrets Manager secrets with various configuration options including automatic rotation and random password generation.

## Features

- AWS Secrets Manager secret creation
- Multiple secret content types (string, key-value pairs, binary)
- Random password generation with customizable parameters
- Automatic secret rotation configuration
- KMS encryption support
- Configurable recovery window

## Usage

### Basic Secret with String Value

```hcl
module "db_password_secret" {
  source = "./modules/secrets_manager"
  
  secret_name = "rds/prod/password"
  description = "Production database password"
  secret_string = "my-super-secret-password"
  
  common_tags = {
    Environment = "prod"
    Project     = "myapp"
  }
}
```

### Secret with Key-Value Pairs

```hcl
module "db_credentials_secret" {
  source = "./modules/secrets_manager"
  
  secret_name = "rds/prod/credentials"
  description = "Production database credentials"
  secret_key_value = {
    username = "dbadmin"
    password = "my-super-secret-password"
    host     = "prod-db.cluster-xyz.region.rds.amazonaws.com"
    port     = "5432"
    dbname   = "production"
  }
  
  common_tags = local.common_tags
}
```

### Secret with Generated Random Password

```hcl
module "auto_generated_secret" {
  source = "./modules/secrets_manager"
  
  secret_name = "rds/dev/auto-password"
  description = "Auto-generated database password"
  
  # Generate random password
  generate_random_password = true
  password_length         = 32
  password_include_special = true
  generated_password_username = "dbadmin"
  
  common_tags = {
    Environment = "dev"
    Project     = "myapp"
  }
}
```

### Secret with KMS Encryption and Rotation

```hcl
module "encrypted_rotating_secret" {
  source = "./modules/secrets_manager"
  
  secret_name = "app/prod/api-key"
  description = "Production API key with rotation"
  secret_string = var.api_key
  
  # KMS Encryption
  kms_key_id = aws_kms_key.secrets.arn
  
  # Automatic Rotation
  enable_rotation      = true
  rotation_lambda_arn  = aws_lambda_function.secret_rotation.arn
  rotation_days       = 90
  
  # Custom recovery window
  recovery_window_in_days = 7
  
  common_tags = local.common_tags
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |
| random | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 4.0 |
| random | >= 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| secret_name | The name of the secret | `string` | n/a | yes |
| description | A description of the secret | `string` | `null` | no |
| secret_string | The text data to encrypt and store | `string` | `null` | no |
| secret_key_value | Map of key-value pairs (JSON-encoded) | `map(string)` | `null` | no |
| secret_binary | The binary data to encrypt and store | `string` | `null` | no |
| generate_random_password | Whether to generate a random password | `bool` | `false` | no |
| password_length | Length of the generated password | `number` | `32` | no |
| kms_key_id | The ARN or Id of the AWS KMS key | `string` | `null` | no |
| enable_rotation | Whether to enable automatic rotation | `bool` | `false` | no |
| rotation_lambda_arn | The ARN of the Lambda function for rotation | `string` | `null` | no |
| rotation_days | Days between automatic rotations | `number` | `30` | no |

## Outputs

| Name | Description |
|------|-------------|
| secret_arn | The ARN of the secret |
| secret_id | The ID of the secret |
| secret_name | The name of the secret |
| secret_version_id | The unique identifier of the secret version |
| generated_password | The generated password (sensitive) |

## Usage with RDS

### Storing RDS Credentials

```hcl
module "rds_credentials" {
  source = "./modules/secrets_manager"
  
  secret_name = "rds/${var.environment}/master-credentials"
  description = "RDS master user credentials"
  secret_key_value = {
    username = "dbadmin"
    password = random_password.rds_master.result
  }
  
  common_tags = local.common_tags
}

# Use in RDS module
module "rds" {
  source = "./modules/rds"
  
  identifier = "my-database"
  username   = jsondecode(data.aws_secretsmanager_secret_version.rds_creds.secret_string)["username"]
  password   = jsondecode(data.aws_secretsmanager_secret_version.rds_creds.secret_string)["password"]
  
  # ... other RDS configuration
}

data "aws_secretsmanager_secret_version" "rds_creds" {
  secret_id = module.rds_credentials.secret_id
}
```

## Security Best Practices

1. Always use KMS encryption for sensitive secrets
2. Enable rotation for long-lived credentials
3. Use appropriate recovery windows
4. Limit access with IAM policies
5. Audit secret access with CloudTrail
6. Use separate secrets for different environments