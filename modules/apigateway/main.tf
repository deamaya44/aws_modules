resource "aws_apigatewayv2_api" "this" {
  name          = var.api_name
  protocol_type = var.protocol_type

  dynamic "cors_configuration" {
    for_each = var.cors_configuration != null ? [var.cors_configuration] : []
    content {
      allow_origins     = cors_configuration.value.allow_origins
      allow_methods     = cors_configuration.value.allow_methods
      allow_headers     = cors_configuration.value.allow_headers
      expose_headers    = try(cors_configuration.value.expose_headers, null)
      max_age           = try(cors_configuration.value.max_age, null)
      allow_credentials = try(cors_configuration.value.allow_credentials, null)
    }
  }

  tags = var.common_tags
}

resource "aws_apigatewayv2_stage" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = var.stage_name
  auto_deploy = var.auto_deploy

  dynamic "default_route_settings" {
    for_each = var.throttling_burst_limit != null ? [1] : []
    content {
      throttling_burst_limit = var.throttling_burst_limit
      throttling_rate_limit  = var.throttling_rate_limit
    }
  }

  tags = var.common_tags
}

resource "aws_apigatewayv2_integration" "this" {
  for_each = var.integrations

  api_id             = aws_apigatewayv2_api.this.id
  integration_type   = each.value.integration_type
  integration_uri    = each.value.integration_uri
  integration_method = try(each.value.integration_method, null)
  payload_format_version = try(each.value.payload_format_version, "2.0")
}

resource "aws_apigatewayv2_route" "this" {
  for_each = var.routes

  api_id             = aws_apigatewayv2_api.this.id
  route_key          = each.value.route_key
  target             = "integrations/${aws_apigatewayv2_integration.this[each.value.integration_key].id}"
  authorization_type = try(each.value.authorization_type, "NONE")
  authorizer_id      = try(aws_apigatewayv2_authorizer.this[each.value.authorizer_id].id, null)
}

resource "aws_apigatewayv2_authorizer" "this" {
  for_each = var.authorizers

  api_id                            = aws_apigatewayv2_api.this.id
  authorizer_type                   = each.value.authorizer_type
  authorizer_uri                    = each.value.authorizer_uri
  identity_sources                  = each.value.identity_sources
  name                              = each.value.name
  authorizer_payload_format_version = try(each.value.payload_format_version, "2.0")
  enable_simple_responses           = try(each.value.enable_simple_responses, false)
}

resource "aws_apigatewayv2_domain_name" "this" {
  count       = var.custom_domain_name != null ? 1 : 0
  domain_name = var.custom_domain_name

  domain_name_configuration {
    certificate_arn = var.certificate_arn
    endpoint_type   = var.endpoint_type
    security_policy = var.security_policy
  }

  tags = var.common_tags
}

resource "aws_apigatewayv2_api_mapping" "this" {
  count       = var.custom_domain_name != null ? 1 : 0
  api_id      = aws_apigatewayv2_api.this.id
  domain_name = aws_apigatewayv2_domain_name.this[0].id
  stage       = aws_apigatewayv2_stage.this.id
}
