########### Example usage of CodeBuild module with locals ###########

locals {
  codebuild_projects = {
    backend_build = {
      project_name     = "my-app-backend-build"
      description      = "Build project for backend Lambda function"
      service_role_arn = "arn:aws:iam::123456789012:role/CodeBuildServiceRole"
      build_timeout    = 30
      compute_type     = "BUILD_GENERAL1_SMALL"
      image            = "aws/codebuild/standard:7.0"
      environment_type = "LINUX_CONTAINER"
      privileged_mode  = false
      source_type      = "CODEPIPELINE"
      buildspec        = "buildspec.yml"
      artifacts_type   = "CODEPIPELINE"
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
        },
        {
          name  = "LAMBDA_FUNCTION_NAME"
          value = "my-app-backend"
          type  = "PLAINTEXT"
        }
      ]
      cache_type  = "LOCAL"
      cache_modes = ["LOCAL_SOURCE_CACHE"]
      tags = {
        Environment = "production"
        Project     = "my-app"
        Component   = "backend"
        Owner       = "dev-team"
      }
    }

    frontend_build = {
      project_name     = "my-app-frontend-build"
      description      = "Build project for frontend React application"
      service_role_arn = "arn:aws:iam::123456789012:role/CodeBuildServiceRole"
      build_timeout    = 20
      compute_type     = "BUILD_GENERAL1_SMALL"
      image            = "aws/codebuild/standard:7.0"
      environment_type = "LINUX_CONTAINER"
      privileged_mode  = false
      source_type      = "CODEPIPELINE"
      buildspec        = "buildspec.yml"
      artifacts_type   = "CODEPIPELINE"
      environment_variables = [
        {
          name  = "NODE_ENV"
          value = "production"
          type  = "PLAINTEXT"
        },
        {
          name  = "S3_BUCKET"
          value = "my-app-frontend-bucket"
          type  = "PLAINTEXT"
        },
        {
          name  = "CLOUDFRONT_DISTRIBUTION_ID"
          value = "E1234567890ABC"
          type  = "PLAINTEXT"
        }
      ]
      cache_type  = "LOCAL"
      cache_modes = ["LOCAL_SOURCE_CACHE", "LOCAL_CUSTOM_CACHE"]
      tags = {
        Environment = "production"
        Project     = "my-app"
        Component   = "frontend"
        Owner       = "frontend-team"
      }
    }

    terraform_build = {
      project_name     = "my-app-terraform-build"
      description      = "Build project for Terraform infrastructure"
      service_role_arn = "arn:aws:iam::123456789012:role/CodeBuildServiceRole"
      build_timeout    = 60
      compute_type     = "BUILD_GENERAL1_SMALL"
      image            = "aws/codebuild/standard:7.0"
      environment_type = "LINUX_CONTAINER"
      privileged_mode  = false
      source_type      = "CODEPIPELINE"
      buildspec        = "buildspec.yml"
      artifacts_type   = "CODEPIPELINE"
      environment_variables = [
        {
          name  = "TF_VERSION"
          value = "1.14.4"
          type  = "PLAINTEXT"
        },
        {
          name  = "AWS_REGION"
          value = "us-east-1"
          type  = "PLAINTEXT"
        }
      ]
      cache_type  = "LOCAL"
      cache_modes = ["LOCAL_SOURCE_CACHE"]
      tags = {
        Environment = "production"
        Project     = "my-app"
        Component   = "infrastructure"
        Owner       = "devops-team"
      }
    }

    docker_build = {
      project_name     = "my-app-docker-build"
      description      = "Build project for Docker images"
      service_role_arn = "arn:aws:iam::123456789012:role/CodeBuildServiceRole"
      build_timeout    = 45
      compute_type     = "BUILD_GENERAL1_MEDIUM"
      image            = "aws/codebuild/standard:7.0"
      environment_type = "LINUX_CONTAINER"
      privileged_mode  = true
      source_type      = "CODEPIPELINE"
      buildspec        = "buildspec.yml"
      artifacts_type   = "CODEPIPELINE"
      environment_variables = [
        {
          name  = "ECR_REPOSITORY_URI"
          value = "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-app"
          type  = "PLAINTEXT"
        },
        {
          name  = "IMAGE_TAG"
          value = "latest"
          type  = "PLAINTEXT"
        }
      ]
      cache_type  = "LOCAL"
      cache_modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
      tags = {
        Environment = "production"
        Project     = "my-app"
        Component   = "docker"
        Owner       = "devops-team"
      }
    }
  }
}
