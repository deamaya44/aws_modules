# CodePipeline
resource "aws_codepipeline" "this" {
  name     = var.pipeline_name
  role_arn = var.role_arn

  artifact_store {
    location = var.artifact_store_location
    type     = var.artifact_store_type

    dynamic "encryption_key" {
      for_each = var.artifact_store_encryption_key_id != null ? [1] : []
      content {
        id   = var.artifact_store_encryption_key_id
        type = var.artifact_store_encryption_key_type
      }
    }
  }

  # Source Stage
  stage {
    name = "Source"

    dynamic "action" {
      for_each = var.source_actions
      content {
        name             = action.value.name
        category         = "Source"
        owner            = action.value.owner
        provider         = action.value.provider
        version          = lookup(action.value, "version", "1")
        output_artifacts = action.value.output_artifacts
        configuration    = action.value.configuration
        run_order        = lookup(action.value, "run_order", 1)
      }
    }
  }

  # Build Stage (optional)
  dynamic "stage" {
    for_each = length(var.build_actions) > 0 ? [1] : []
    content {
      name = "Build"

      dynamic "action" {
        for_each = var.build_actions
        content {
          name             = action.value.name
          category         = "Build"
          owner            = "AWS"
          provider         = "CodeBuild"
          version          = lookup(action.value, "version", "1")
          input_artifacts  = action.value.input_artifacts
          output_artifacts = lookup(action.value, "output_artifacts", [])
          configuration    = action.value.configuration
          run_order        = lookup(action.value, "run_order", 1)
        }
      }
    }
  }

  # Deploy Stage (optional)
  dynamic "stage" {
    for_each = length(var.deploy_actions) > 0 ? [1] : []
    content {
      name = "Deploy"

      dynamic "action" {
        for_each = var.deploy_actions
        content {
          name            = action.value.name
          category        = "Deploy"
          owner           = lookup(action.value, "owner", "AWS")
          provider        = action.value.provider
          version         = lookup(action.value, "version", "1")
          input_artifacts = action.value.input_artifacts
          configuration   = action.value.configuration
          run_order       = lookup(action.value, "run_order", 1)
        }
      }
    }
  }

  # Approval Stage (optional)
  dynamic "stage" {
    for_each = length(var.approval_actions) > 0 ? [1] : []
    content {
      name = "Approval"

      dynamic "action" {
        for_each = var.approval_actions
        content {
          name          = action.value.name
          category      = "Approval"
          owner         = "AWS"
          provider      = "Manual"
          version       = "1"
          configuration = lookup(action.value, "configuration", {})
          run_order     = lookup(action.value, "run_order", 1)
        }
      }
    }
  }

  # Custom Stages (optional)
  dynamic "stage" {
    for_each = var.custom_stages
    content {
      name = stage.value.name

      dynamic "action" {
        for_each = stage.value.actions
        content {
          name             = action.value.name
          category         = action.value.category
          owner            = action.value.owner
          provider         = action.value.provider
          version          = lookup(action.value, "version", "1")
          input_artifacts  = lookup(action.value, "input_artifacts", [])
          output_artifacts = lookup(action.value, "output_artifacts", [])
          configuration    = action.value.configuration
          run_order        = lookup(action.value, "run_order", 1)
        }
      }
    }
  }

  tags = merge(
    var.common_tags,
    {
      Name = var.pipeline_name
    }
  )
}

# EventBridge Rule for automatic pipeline execution (optional)
resource "aws_cloudwatch_event_rule" "this" {
  count = var.create_eventbridge_rule ? 1 : 0

  name        = "${var.pipeline_name}-trigger"
  description = "Trigger CodePipeline on repository changes"

  event_pattern = jsonencode({
    source      = ["aws.codecommit"]
    detail-type = ["CodeCommit Repository State Change"]
    detail = {
      event         = ["referenceCreated", "referenceUpdated"]
      referenceType = ["branch"]
      referenceName = var.eventbridge_branch_names
    }
    resources = var.eventbridge_repository_arns
  })

  tags = var.common_tags
}

resource "aws_cloudwatch_event_target" "this" {
  count = var.create_eventbridge_rule ? 1 : 0

  rule      = aws_cloudwatch_event_rule.this[0].name
  target_id = "CodePipeline"
  arn       = aws_codepipeline.this.arn
  role_arn  = var.eventbridge_role_arn
}
