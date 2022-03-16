locals {
  api = {
    name     = "api"
  }
}

resource "aws_apigatewayv2_api" "backend" {
  name          = "${var.project}-api"
  tags          = var.tags
  protocol_type = "HTTP"

  body = templatefile("${path.root}/../common/api/openapi.yaml", {
    INTEGRATION = <<EOT
x-amazon-apigateway-integration:
          payloadFormatVersion: "1.0"
          type: "aws_proxy"
          httpMethod: "POST"
          uri: "${aws_lambda_function.backend.invoke_arn}"
          connectionType: "INTERNET"
                EOT
  })

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["*"]
    allow_headers = ["*"]
  }
}

resource "aws_apigatewayv2_stage" "deployment" {
  name        = local.api.name
  tags        = var.tags
  api_id      = aws_apigatewayv2_api.backend.id
  auto_deploy = true

  default_route_settings {
    throttling_burst_limit = 10
    throttling_rate_limit  = 10
  }
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.backend.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.backend.execution_arn}/*/*"
}
