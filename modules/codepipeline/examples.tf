########### Example usage of CodePipeline module with locals ###########

locals {
  codepipelines = {
    backend_pipeline = {
      pipeline_name           = "my-app-backend-pipeline"
      role_arn                = "arn:aws:iam::123456789012:role/CodePipelineServiceRole"
      artifact_store_location = "my-app-artifacts-bucket"
      source_actions = [
        {
          name             = "Source"
          owner            = "AWS"
          provider         = "CodeCommit"
          output_artifacts = ["source_output"]
          configuration = {
            RepositoryName = "my-app-backend"
            BranchName     = "main"
          }
        }
      ]
      build_actions = [
        {
          name             = "Build"
          input_artifacts  = ["source_output"]
          output_artifacts = ["build_output"]
          configuration = {
            ProjectName = "my-app-backend-build"
          }
        }
      ]
      deploy_actions = [
        {
          name            = "Deploy"
          provider        = "Lambda"
          input_artifacts = ["build_output"]
          configuration = {
            FunctionName = "my-app-backend"
          }
        }
      ]
      create_eventbridge_rule     = true
      eventbridge_branch_names    = ["main"]
      eventbridge_repository_arns = ["arn:aws:codecommit:us-east-1:123456789012:my-app-backend"]
      eventbridge_role_arn        = "arn:aws:iam::123456789012:role/EventBridgeCodePipelineRole"
      tags = {
        Environment = "production"
        Project     = "my-app"
        Component   = "backend"
        Owner       = "dev-team"
      }
    }

    frontend_pipeline = {
      pipeline_name           = "my-app-frontend-pipeline"
      role_arn                = "arn:aws:iam::123456789012:role/CodePipelineServiceRole"
      artifact_store_location = "my-app-artifacts-bucket"
      source_actions = [
        {
          name             = "Source"
          owner            = "AWS"
          provider         = "CodeCommit"
          output_artifacts = ["source_output"]
          configuration = {
            RepositoryName = "my-app-frontend"
            BranchName     = "main"
          }
        }
      ]
      build_actions = [
        {
          name             = "Build"
          input_artifacts  = ["source_output"]
          output_artifacts = ["build_output"]
          configuration = {
            ProjectName = "my-app-frontend-build"
          }
        }
      ]
      deploy_actions = [
        {
          name            = "Deploy"
          provider        = "S3"
          input_artifacts = ["build_output"]
          configuration = {
            BucketName = "my-app-frontend-bucket"
            Extract    = "true"
          }
        }
      ]
      create_eventbridge_rule     = true
      eventbridge_branch_names    = ["main"]
      eventbridge_repository_arns = ["arn:aws:codecommit:us-east-1:123456789012:my-app-frontend"]
      eventbridge_role_arn        = "arn:aws:iam::123456789012:role/EventBridgeCodePipelineRole"
      tags = {
        Environment = "production"
        Project     = "my-app"
        Component   = "frontend"
        Owner       = "frontend-team"
      }
    }

    terraform_pipeline = {
      pipeline_name           = "my-app-terraform-pipeline"
      role_arn                = "arn:aws:iam::123456789012:role/CodePipelineServiceRole"
      artifact_store_location = "my-app-artifacts-bucket"
      source_actions = [
        {
          name             = "Source"
          owner            = "AWS"
          provider         = "CodeCommit"
          output_artifacts = ["source_output"]
          configuration = {
            RepositoryName = "my-app-infrastructure"
            BranchName     = "main"
          }
        }
      ]
      build_actions = [
        {
          name             = "Plan"
          input_artifacts  = ["source_output"]
          output_artifacts = ["plan_output"]
          configuration = {
            ProjectName = "my-app-terraform-plan"
          }
        }
      ]
      approval_actions = [
        {
          name = "ApprovalRequired"
          configuration = {
            CustomData = "Please review Terraform plan before applying"
          }
        }
      ]
      custom_stages = [
        {
          name = "Apply"
          actions = [
            {
              name            = "TerraformApply"
              category        = "Build"
              owner           = "AWS"
              provider        = "CodeBuild"
              input_artifacts = ["source_output"]
              configuration = {
                ProjectName = "my-app-terraform-apply"
              }
            }
          ]
        }
      ]
      create_eventbridge_rule     = true
      eventbridge_branch_names    = ["main"]
      eventbridge_repository_arns = ["arn:aws:codecommit:us-east-1:123456789012:my-app-infrastructure"]
      eventbridge_role_arn        = "arn:aws:iam::123456789012:role/EventBridgeCodePipelineRole"
      tags = {
        Environment = "production"
        Project     = "my-app"
        Component   = "infrastructure"
        Owner       = "devops-team"
      }
    }

    multi_source_pipeline = {
      pipeline_name           = "my-app-multi-source-pipeline"
      role_arn                = "arn:aws:iam::123456789012:role/CodePipelineServiceRole"
      artifact_store_location = "my-app-artifacts-bucket"
      source_actions = [
        {
          name             = "BackendSource"
          owner            = "AWS"
          provider         = "CodeCommit"
          output_artifacts = ["backend_source"]
          configuration = {
            RepositoryName = "my-app-backend"
            BranchName     = "main"
          }
          run_order = 1
        },
        {
          name             = "FrontendSource"
          owner            = "AWS"
          provider         = "CodeCommit"
          output_artifacts = ["frontend_source"]
          configuration = {
            RepositoryName = "my-app-frontend"
            BranchName     = "main"
          }
          run_order = 1
        }
      ]
      build_actions = [
        {
          name             = "BuildBackend"
          input_artifacts  = ["backend_source"]
          output_artifacts = ["backend_build"]
          configuration = {
            ProjectName = "my-app-backend-build"
          }
          run_order = 1
        },
        {
          name             = "BuildFrontend"
          input_artifacts  = ["frontend_source"]
          output_artifacts = ["frontend_build"]
          configuration = {
            ProjectName = "my-app-frontend-build"
          }
          run_order = 1
        }
      ]
      tags = {
        Environment = "production"
        Project     = "my-app"
        Component   = "multi-source"
        Owner       = "dev-team"
      }
    }
  }
}
