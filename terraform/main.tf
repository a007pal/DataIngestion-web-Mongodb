provider "aws" {
  region = var.region
}
#Aws Lambda
resource "aws_iam_role" "lambda_execution_role" {
    name = "${var.funtion_name}-execution-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Action = "sts:AssumeRole",
                Effect = "Allow",
                Principal = {
                    Service = "lambda.amazonaws.com"
                }
            }
        ]

    })
  
}
resource "aws_iam_role_policy_attachment" "lambda_logs" {
    role = aws_iam_role.lambda_execution_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  
}

resource "aws_lambda_function" "micronaut_lambda" {
  filename = "property-view-tracker-0.1-lambda.zip"
  function_name = var.funtion_name
  role = aws_iam_role.lambda_execution_role.arn
  handler = "io.micronaut.function.aws.runtime.APIGatewayV2HTTPEventMicronautLambdaRuntime"
  source_code_hash = filebase64sha256("property-view-tracker-0.1-lambda.zip")
  runtime = "provided.al2023"
  architectures = ["x86_64"]

  environment {
    variables = {
      "MICRONAUT_ENVIRONMENTS" = var.environment
      API_STAGE= var.environment
    }
  }
  timeout = 240
  memory_size = 512
}

#Api GateWay Start

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
  integration_method     = "POST" // This is correct for Lambda proxy integration, even for GET routes
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "lambda_route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "GET /property/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_intergration.id}"
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