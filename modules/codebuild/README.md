# CodeBuild Module

This module creates an AWS CodeBuild project with support for various source types, artifacts, caching, and VPC configuration.

## Features

- CodeBuild project creation
- Multiple source types (CodeCommit, CodePipeline, GitHub, S3)
- Artifact management (S3, CodePipeline)
- Environment variables support
- VPC configuration for private resources
- Build caching (S3, LOCAL)
- CloudWatch and S3 logs
- Privileged mode for Docker builds

## Usage

```hcl
module "codebuild" {
  source = "git::ssh://git@github.com/deamaya44/aws_modules.git//modules/codebuild?ref=main"

  project_name     = "my-app-build"
  description      = "Build project for my application"
  service_role_arn = aws_iam_role.codebuild.arn
  build_timeout    = 30

  # Environment
  compute_type    = "BUILD_GENERAL1_SMALL"
  image           = "aws/codebuild/standard:7.0"
  privileged_mode = true

  environment_variables = [
    {
      name  = "AWS_REGION"
      value = "us-east-1"
      type  = "PLAINTEXT"
    },
    {
      name  = "ARTIFACTS_BUCKET"
      value = "my-artifacts-bucket"
      type  = "PLAINTEXT"
    }
  ]

  # Source from CodePipeline
  source_type = "CODEPIPELINE"
  buildspec   = "buildspec.yml"

  # Artifacts to CodePipeline
  artifacts_type = "CODEPIPELINE"

  # Cache
  cache_type = "LOCAL"
  cache_modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]

  common_tags = {
    Environment = "dev"
    Project     = "my-project"
  }
}
```

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| project_name | Name of the CodeBuild project | string | - | yes |
| service_role_arn | ARN of the IAM role for CodeBuild | string | - | yes |
| compute_type | Compute type | string | BUILD_GENERAL1_SMALL | no |
| image | Docker image to use | string | aws/codebuild/standard:7.0 | no |
| privileged_mode | Enable privileged mode for Docker | bool | false | no |
| source_type | Source type | string | CODEPIPELINE | no |
| artifacts_type | Artifacts type | string | CODEPIPELINE | no |
| environment_variables | List of environment variables | list(object) | [] | no |
| cache_type | Cache type | string | null | no |
| vpc_id | VPC ID for CodeBuild | string | null | no |
| common_tags | Common tags | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| project_id | The ID of the CodeBuild project |
| project_name | The name of the CodeBuild project |
| arn | The ARN of the CodeBuild project |
| badge_url | The URL of the build badge |
| log_group_name | The name of the CloudWatch log group |

## Examples

See `examples.tf` for complete configuration examples.
