resource "aws_iam_role" "lambda_execution_role" {
    name = "${var.function_name}-execution-role"
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

resource "aws_iam_policy" "lambda_secert_access" {
  name        = "${var.function_name}-lambda-secrets-access"
  description = "Policy to allow Lambda function to access secrets in Secrets Manager"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue"
        ],
        Resource = [var.sasl_secret_arn, var.tls_secret_arn]
      }
    ]
  })
}
resource "aws_lambda_function" "micronaut_lambda" {
  filename         = "../build_output/lambda.zip"
  function_name    = var.function_name
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "io.micronaut.function.aws.runtime.APIGatewayV2HTTPEventMicronautLambdaRuntime"
  source_code_hash = filebase64sha256("../build_output/lambda.zip")
  runtime          = "provided.al2023"
  architectures    = ["x86_64"]
  #publish = true
  vpc_config {
    security_group_ids = var.sg_lambda
    subnet_ids         = var.private_subnet_ids
  }

  environment {
    variables = {
      "MICRONAUT_ENVIRONMENTS" = var.environment
      API_STAGE                = var.environment
    }
  }
  timeout   = 240
  memory_size = 512
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [vpc_config]
  }
}