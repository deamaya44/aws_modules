resource "aws_amplify_app" "this" {
  name = var.app_name

  # Manual deployment - no repository connection
  platform = "WEB"

  build_spec = var.build_spec != "" ? var.build_spec : <<-EOT
    version: 1
    frontend:
      phases:
        build:
          commands:
            - echo "Build handled by CodeBuild"
      artifacts:
        baseDirectory: /
        files:
          - '**/*'
  EOT

  dynamic "environment_variables" {
    for_each = var.environment_variables
    content {
      name  = environment_variables.key
      value = environment_variables.value
    }
  }

  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }

  custom_rule {
    source = "</^[^.]+$|\\.(?!(css|gif|ico|jpg|js|png|txt|svg|woff|ttf|map|json)$)([^.]+$)/>"
    status = "200"
    target = "/index.html"
  }

  tags = var.common_tags
}

resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.this.id
  branch_name = var.branch_name

  enable_auto_build = false  # Manual deployment

  dynamic "environment_variables" {
    for_each = var.environment_variables
    content {
      name  = environment_variables.key
      value = environment_variables.value
    }
  }

  tags = var.common_tags
}

resource "aws_amplify_domain_association" "this" {
  count = var.custom_domain != "" ? 1 : 0

  app_id      = aws_amplify_app.this.id
  domain_name = var.custom_domain

  sub_domain {
    branch_name = aws_amplify_branch.main.branch_name
    prefix      = var.subdomain_prefix
  }
}
