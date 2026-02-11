# CodeBuild Project
resource "aws_codebuild_project" "this" {
  name          = var.project_name
  description   = var.description
  service_role  = var.service_role_arn
  build_timeout = var.build_timeout

  artifacts {
    type                   = var.artifacts_type
    location               = var.artifacts_location
    name                   = var.artifacts_name
    namespace_type         = var.artifacts_namespace_type
    packaging              = var.artifacts_packaging
    encryption_disabled    = var.artifacts_encryption_disabled
    override_artifact_name = var.artifacts_override_name
  }

  environment {
    compute_type                = var.compute_type
    image                       = var.image
    type                        = var.environment_type
    image_pull_credentials_type = var.image_pull_credentials_type
    privileged_mode             = var.privileged_mode

    dynamic "environment_variable" {
      for_each = var.environment_variables
      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
        type  = lookup(environment_variable.value, "type", "PLAINTEXT")
      }
    }
  }

  source {
    type            = var.source_type
    location        = var.source_location
    buildspec       = var.buildspec
    git_clone_depth = var.git_clone_depth

    dynamic "git_submodules_config" {
      for_each = var.fetch_git_submodules ? [1] : []
      content {
        fetch_submodules = true
      }
    }
  }

  # VPC Configuration (optional)
  dynamic "vpc_config" {
    for_each = var.vpc_id != null ? [1] : []
    content {
      vpc_id             = var.vpc_id
      subnets            = var.subnets
      security_group_ids = var.security_group_ids
    }
  }

  # Cache Configuration (optional)
  dynamic "cache" {
    for_each = var.cache_type != null ? [1] : []
    content {
      type     = var.cache_type
      location = var.cache_location
      modes    = var.cache_modes
    }
  }

  # Logs Configuration
  logs_config {
    cloudwatch_logs {
      status      = var.cloudwatch_logs_status
      group_name  = var.cloudwatch_logs_group_name
      stream_name = var.cloudwatch_logs_stream_name
    }

    dynamic "s3_logs" {
      for_each = var.s3_logs_status != null ? [1] : []
      content {
        status              = var.s3_logs_status
        location            = var.s3_logs_location
        encryption_disabled = var.s3_logs_encryption_disabled
      }
    }
  }

  tags = merge(
    var.common_tags,
    {
      Name = var.project_name
    }
  )
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "this" {
  count = var.create_log_group ? 1 : 0

  name              = "/aws/codebuild/${var.project_name}"
  retention_in_days = var.log_retention_days

  tags = merge(
    var.common_tags,
    {
      Name = "/aws/codebuild/${var.project_name}"
    }
  )
}
