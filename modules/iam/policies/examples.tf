########### Example usage of IAM Policies module with locals and for_each ###########

# Define IAM policies configuration in locals
locals {
  iam_policies = {
    s3_read_only = {
      policy_name = "S3ReadOnlyPolicy"
      description = "Policy for read-only access to S3 buckets"
      policy_document = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "s3:GetObject",
              "s3:GetObjectVersion",
              "s3:ListBucket"
            ]
            Resource = [
              "arn:aws:s3:::my-app-bucket",
              "arn:aws:s3:::my-app-bucket/*"
            ]
          }
        ]
      })
      attach_to_roles = ["EC2InstanceRole", "LambdaExecutionRole"]
      tags = {
        Environment = "production"
        Project     = "web-app"
        Owner       = "devops-team"
        Type        = "s3-policy"
      }
    }

    cloudwatch_logs = {
      policy_name = "CloudWatchLogsPolicy"
      description = "Policy for writing logs to CloudWatch"
      policy_document = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "logs:CreateLogGroup",
              "logs:CreateLogStream",
              "logs:PutLogEvents",
              "logs:DescribeLogStreams"
            ]
            Resource = "arn:aws:logs:*:*:*"
          }
        ]
      })
      attach_to_roles = ["LambdaExecutionRole", "EC2InstanceRole"]
      tags = {
        Environment = "production"
        Project     = "logging"
        Owner       = "devops-team"
        Type        = "cloudwatch-policy"
      }
    }

      rds_connect = {
      policy_name = "RDSConnectPolicy"
      description = "Policy for connecting to RDS databases"
      policy_document = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "rds-db:connect"
            ]
            Resource = [
              "arn:aws:rds-db:us-east-1:*:dbuser:*/lambda-user"
            ]
          }
        ]
      })
      attach_to_roles = ["LambdaExecutionRole"]
      tags = {
        Environment = "production"
        Project     = "database"
        Owner       = "dev-team"
        Type        = "rds-policy"
      }
    }

    secrets_manager = {
      policy_name = "SecretsManagerPolicy"
      description = "Policy for accessing secrets in Secrets Manager"
      policy_document = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "secretsmanager:GetSecretValue",
              "secretsmanager:DescribeSecret"
            ]
            Resource = "arn:aws:secretsmanager:*:*:secret:app/*"
          }
        ]
      })
      attach_to_roles = ["LambdaExecutionRole"]
      tags = {
        Environment = "production"
        Project     = "security"
        Owner       = "security-team"
        Type        = "secrets-policy"
      }
    }
  }
}

# IAM Policies Module with for_each
# module "iam_policies" {
#   source   = "git::ssh://git@github.com/deamaya44/aws_modules.git//modules/iam_policies?ref=main"
#   for_each = local.iam_policies
#   
#   # Policy Configuration
#   policy_name     = each.value.policy_name
#   description     = each.value.description
#   policy_document = each.value.policy_document
#   
#   # Attachments (optional)
#   attach_to_roles  = lookup(each.value, "attach_to_roles", [])
#   attach_to_users  = lookup(each.value, "attach_to_users", [])
#   attach_to_groups = lookup(each.value, "attach_to_groups", [])
#   
#   # Common Tags
#   common_tags = each.value.tags
# }

# Example of Integration: Policies created first, then referenced in roles
# First create the policies above, then use them in roles like this:
#
# module "iam_roles" {
#   source   = "git::ssh://git@github.com/deamaya44/aws_modules.git//modules/iam_roles?ref=main"
#   for_each = local.iam_roles  # Define in your locals
#   
#   role_name          = each.value.role_name
#   assume_role_policy = each.value.assume_role_policy
#   
#   # Reference custom policies created by the iam_policies module
#   custom_policy_arns = [
#     module.iam_policies["s3_read_only"].policy_arn,
#     module.iam_policies["cloudwatch_logs"].policy_arn
#   ]
#   
#   # Also attach AWS managed policies
#   aws_managed_policy_arns = each.value.aws_managed_policy_arns
#   
#   common_tags = each.value.tags
# }