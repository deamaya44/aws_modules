# CodePipeline Module

This module creates an AWS CodePipeline with support for multiple stages (Source, Build, Deploy, Approval) and automatic triggers via EventBridge.

## Features

- CodePipeline creation with multiple stages
- Source stage (CodeCommit, GitHub, S3)
- Build stage (CodeBuild)
- Deploy stage (Lambda, ECS, S3, CloudFormation)
- Manual approval stage
- Custom stages support
- EventBridge automatic triggers
- Artifact encryption with KMS
- Tagging support

## Usage

```hcl
module "codepipeline" {
  source = "git::ssh://git@github.com/deamaya44/aws_modules.git//modules/codepipeline?ref=main"

  pipeline_name           = "my-app-pipeline"
  role_arn                = aws_iam_role.codepipeline.arn
  artifact_store_location = "my-artifacts-bucket"

  # Source Stage
  source_actions = [
    {
      name             = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      output_artifacts = ["source_output"]
      configuration = {
        RepositoryName = "my-app-repo"
        BranchName     = "main"
      }
    }
  ]

  # Build Stage
  build_actions = [
    {
      name             = "Build"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      configuration = {
        ProjectName = "my-app-build"
      }
    }
  ]

  # Deploy Stage
  deploy_actions = [
    {
      name            = "Deploy"
      provider        = "Lambda"
      input_artifacts = ["build_output"]
      configuration = {
        FunctionName = "my-app-function"
      }
    }
  ]

  # EventBridge automatic trigger
  create_eventbridge_rule    = true
  eventbridge_branch_names   = ["main"]
  eventbridge_repository_arns = [aws_codecommit_repository.repo.arn]
  eventbridge_role_arn       = aws_iam_role.eventbridge.arn

  common_tags = {
    Environment = "dev"
    Project     = "my-project"
  }
}
```

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| pipeline_name | Name of the CodePipeline | string | - | yes |
| role_arn | ARN of the IAM role for CodePipeline | string | - | yes |
| artifact_store_location | S3 bucket for pipeline artifacts | string | - | yes |
| source_actions | List of source actions | list(object) | - | yes |
| build_actions | List of build actions | list(object) | [] | no |
| deploy_actions | List of deploy actions | list(object) | [] | no |
| approval_actions | List of manual approval actions | list(object) | [] | no |
| custom_stages | List of custom stages | list(object) | [] | no |
| create_eventbridge_rule | Create EventBridge rule for triggers | bool | false | no |
| common_tags | Common tags | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| pipeline_id | The ID of the CodePipeline |
| pipeline_name | The name of the CodePipeline |
| arn | The ARN of the CodePipeline |
| eventbridge_rule_arn | The ARN of the EventBridge rule |

## Examples

See `examples.tf` for complete configuration examples.
