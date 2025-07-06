output "lambda_function_name" {
  value       = aws_lambda_function.micronaut_lambda.function_name
  description = "The name of the deployed Lambda function"
}

output "lambda_function_arn" {
  value       = aws_lambda_function.micronaut_lambda.arn
  description = "ARN of the Lambda function"
}

output "lambda_invoke_arn" {
  value       = aws_lambda_function.micronaut_lambda.invoke_arn
  description = "Invoke ARN used by API Gateway integration"
}

output "lambda_execution_role_arn" {
  value       = aws_iam_role.lambda_execution_role.arn
  description = "IAM role ARN used by Lambda function"
}
