resource "aws_apigatewayv2_api" "api" {
    name = "${var.funtion_name}-api"
    protocol_type = "HTTP"
    description = "API for ${var.funtion_name}"
}

# Api Gateway permission to invoke Lambda
resource "aws_lambda_permission" "api_gateway" {
    statement_id = "AllowApiGatewayInvoke"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.micronaut_lambda.arn
    principal = "apigateway.amazonaws.com"
    source_arn = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
  
}
# Api Gateway integration with Lambda
resource "aws_apigatewayv2_integration" "lambda_intergration" {
  api_id                 = aws_apigatewayv2_api.api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.micronaut_lambda.invoke_arn
  #integration_uri        = aws_lambda_alias.dev.invoke_arn
  integration_method     = "POST" // This is correct for Lambda proxy integration, even for GET routes
  payload_format_version = "2.0"
}
resource "aws_apigatewayv2_authorizer" "auth0_authorizer" {
  name = "${var.funtion_name}-auth0-authorizer"
  api_id = aws_apigatewayv2_api.api.id
  authorizer_type = "JWT"
  identity_sources = ["$request.header.Authorization"]
  jwt_configuration {
    audience = [var.audience]
    issuer = var.issuer
  }  
}
# resource "aws_apigatewayv2_route" "lambda_route" {
#   api_id    = aws_apigatewayv2_api.api.id
#   route_key = "GET /property/{id}"
#   target    = "integrations/${aws_apigatewayv2_integration.lambda_intergration.id}"
# }
resource "aws_apigatewayv2_route" "lambda_route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "POST /property/view"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_intergration.id}"
  authorization_type = "JWT"
  authorizer_id = aws_apigatewayv2_authorizer.auth0_authorizer.id
}


resource "aws_cloudwatch_log_group" "api_gw_logs" {
  name              = "/aws/apigateway/${var.funtion_name}-api"
  retention_in_days = 14
}

resource "aws_apigatewayv2_stage" "api_stage" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = var.environment
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw_logs.arn
    format = jsonencode({
      requestId      = "$context.requestId"
      ip             = "$context.identity.sourceIp"
      requestTime    = "$context.requestTime"
      httpMethod     = "$context.httpMethod"
      routeKey       = "$context.routeKey"
      status         = "$context.status"
      protocol       = "$context.protocol"
      responseLength = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      // Note: HTTP API access logs do not support logging the full request body.
      // To log request/response bodies, you must do so in your Lambda function code.
    })
  }
}