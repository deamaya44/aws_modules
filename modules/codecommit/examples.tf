########### Example usage of CodeCommit module with locals ###########

locals {
  codecommit_repos = {
    backend = {
      repository_name = "my-app-backend"
      description     = "Backend API repository"
      default_branch  = "main"
      create_trigger  = true
      triggers = [
        {
          name            = "notify-on-push"
          destination_arn = "arn:aws:sns:us-east-1:123456789012:codecommit-notifications"
          events          = ["all"]
          branches        = ["main", "develop"]
        }
      ]
      create_approval_rule           = true
      approval_rule_description      = "Require 1 approval for main branch"
      approval_rule_branches         = ["refs/heads/main"]
      approval_rule_approvals_needed = 1
      approval_rule_members = [
        "arn:aws:iam::123456789012:user/tech-lead"
      ]
      tags = {
        Environment = "production"
        Project     = "my-app"
        Component   = "backend"
        Owner       = "dev-team"
      }
    }

    frontend = {
      repository_name = "my-app-frontend"
      description     = "Frontend application repository"
      default_branch  = "main"
      create_trigger  = false
      tags = {
        Environment = "production"
        Project     = "my-app"
        Component   = "frontend"
        Owner       = "frontend-team"
      }
    }

    infrastructure = {
      repository_name                = "my-app-infrastructure"
      description                    = "Terraform infrastructure repository"
      default_branch                 = "main"
      create_approval_rule           = true
      approval_rule_description      = "Require 2 approvals for infrastructure changes"
      approval_rule_branches         = ["refs/heads/main"]
      approval_rule_approvals_needed = 2
      approval_rule_members = [
        "arn:aws:iam::123456789012:user/devops-lead",
        "arn:aws:iam::123456789012:user/security-lead"
      ]
      tags = {
        Environment = "production"
        Project     = "my-app"
        Component   = "infrastructure"
        Owner       = "devops-team"
      }
    }
  }
}
