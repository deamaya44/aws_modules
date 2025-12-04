########### Example usage of IAM Roles module with locals and for_each ###########

# Define IAM roles configuration in locals
locals {
  iam_roles = {
    ec2_instance_role = {
      role_name               = "EC2InstanceRole"
      description             = "IAM role for EC2 instances"
      create_instance_profile = true
      max_session_duration    = 3600
      assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
              Service = "ec2.amazonaws.com"
            }
          }
        ]
      })
      aws_managed_policy_arns = [
        "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
        "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
      ]
      custom_policy_arns = [
        # These will reference policies created by the iam_policies module
        # Example: module.iam_policies["s3_read_only"].policy_arn,
        # Example: module.iam_policies["cloudwatch_logs"].policy_arn
      ]
      inline_policies = [
        {
          name = "S3AccessPolicy"
          policy = jsonencode({
            Version = "2012-10-17"
            Statement = [
              {
                Effect = "Allow"
                Action = [
                  "s3:GetObject",
                  "s3:PutObject"
                ]
                Resource = "arn:aws:s3:::my-bucket/*"
              }
            ]
          })
        }
      ]
      tags = {
        Environment = "production"
        Project     = "web-app"
        Owner       = "devops-team"
        Type        = "ec2-role"
      }
    }

    lambda_execution_role = {
      role_name            = "LambdaExecutionRole"
      description          = "IAM role for Lambda functions"
      max_session_duration = 3600
      assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
              Service = "lambda.amazonaws.com"
            }
          }
        ]
      })
      aws_managed_policy_arns = [
        "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
      ]
      custom_policy_arns = [
        # These will reference policies created by the iam_policies module
        # Example: module.iam_policies["s3_read_only"].policy_arn,
        # Example: module.iam_policies["secrets_manager"].policy_arn,
        # Example: module.iam_policies["rds_connect"].policy_arn
      ]
      tags = {
        Environment = "production"
        Project     = "serverless-app"
        Owner       = "dev-team"
        Type        = "lambda-role"
      }
    }

    cross_account_role = {
      role_name            = "CrossAccountRole"
      description          = "IAM role for cross-account access"
      max_session_duration = 7200
      assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
              AWS = "arn:aws:iam::123456789012:root"
            }
            Condition = {
              StringEquals = {
                "sts:ExternalId" = "unique-external-id"
              }
            }
          }
        ]
      })
      tags = {
        Environment = "production"
        Project     = "multi-account"
        Owner       = "security-team"
        Type        = "cross-account-role"
      }
    }
  }
}

# IAM Roles Module with for_each
# module "iam_roles" {
#   source   = "git::ssh://git@github.com/deamaya44/aws_modules.git//modules/iam_roles?ref=main"
#   for_each = local.iam_roles
#   
#   # Role Configuration
#   role_name               = each.value.role_name
#   description            = each.value.description
#   assume_role_policy     = each.value.assume_role_policy
#   max_session_duration   = each.value.max_session_duration
#   create_instance_profile = lookup(each.value, "create_instance_profile", false)
#   
#   # Policies
#   aws_managed_policy_arns = lookup(each.value, "aws_managed_policy_arns", [])
#   custom_policy_arns     = lookup(each.value, "custom_policy_arns", [])
#   inline_policies        = lookup(each.value, "inline_policies", [])
#   
#   # Common Tags
#   common_tags = each.value.tags
# }