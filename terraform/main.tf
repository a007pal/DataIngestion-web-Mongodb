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
resource "aws_iam_role_policy_attachment" "lambda_vpc_execution" {
  role = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_lambda_function" "micronaut_lambda" {
  filename = "property-view-tracker-0.1-lambda.zip"
  function_name = var.funtion_name
  role = aws_iam_role.lambda_execution_role.arn
  handler = "io.micronaut.function.aws.runtime.APIGatewayV2HTTPEventMicronautLambdaRuntime"
  source_code_hash = filebase64sha256("property-view-tracker-0.1-lambda.zip")
  runtime = "provided.al2023"
  architectures = ["x86_64"]
  #publish = true
  vpc_config {
    security_group_ids = [aws_security_group.lambda_sg.id]
    subnet_ids = [aws_subnet.private_subnet.id]
  }

  environment {
    variables = {
      "MICRONAUT_ENVIRONMENTS" = var.environment
      API_STAGE= var.environment
    }
  }
  timeout = 240
  memory_size = 512
  lifecycle {
  create_before_destroy = true
  ignore_changes        = [vpc_config]
}
}

# resource "aws_lambda_alias" "dev" {
#   name = "dev"
#   function_name = aws_lambda_function.micronaut_lambda.function_name
#   function_version = aws_lambda_function.micronaut_lambda.version
# }

# resource "aws_lambda_provisioned_concurrency_config" "micronaut_lambda_pc" {
#   function_name = aws_lambda_function.micronaut_lambda.function_name
#   qualifier = aws_lambda_alias.dev.name
#   provisioned_concurrent_executions = 1
#     depends_on = [
#     aws_lambda_alias.dev
#   ]
# }

