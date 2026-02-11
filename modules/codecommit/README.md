# CodeCommit Module

This module creates an AWS CodeCommit repository with optional triggers and approval rules.

## Features

- CodeCommit repository creation
- Custom default branch
- SNS/Lambda triggers support
- Approval rule templates for pull requests
- Tagging support

## Usage

```hcl
module "codecommit" {
  source = "git::ssh://git@github.com/deamaya44/aws_modules.git//modules/codecommit?ref=main"

  repository_name = "my-app-repo"
  description     = "Application source code repository"
  default_branch  = "main"

  # Optional: Create triggers
  create_trigger = true
  triggers = [
    {
      name            = "notify-on-push"
      destination_arn = "arn:aws:sns:us-east-1:123456789012:my-topic"
      events          = ["all"]
      branches        = ["main", "develop"]
    }
  ]

  # Optional: Approval rules
  create_approval_rule           = true
  approval_rule_description      = "Require 2 approvals for main branch"
  approval_rule_branches         = ["refs/heads/main"]
  approval_rule_approvals_needed = 2
  approval_rule_members = [
    "arn:aws:iam::123456789012:user/reviewer1",
    "arn:aws:iam::123456789012:user/reviewer2"
  ]

  common_tags = {
    Environment = "dev"
    Project     = "my-project"
  }
}
```

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| repository_name | Name of the CodeCommit repository | string | - | yes |
| description | Description of the repository | string | "" | no |
| default_branch | Default branch name | string | "main" | no |
| create_trigger | Whether to create CodeCommit triggers | bool | false | no |
| triggers | List of triggers for the repository | list(object) | [] | no |
| create_approval_rule | Whether to create approval rule template | bool | false | no |
| approval_rule_approvals_needed | Number of approvals needed | number | 1 | no |
| common_tags | Common tags to apply to all resources | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| repository_id | The ID of the repository |
| repository_name | The name of the repository |
| arn | The ARN of the repository |
| clone_url_http | The URL to use for cloning over HTTPS |
| clone_url_ssh | The URL to use for cloning over SSH |
| default_branch | The default branch of the repository |

## Examples

See `examples.tf` for complete configuration examples.
