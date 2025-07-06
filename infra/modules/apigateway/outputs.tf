output "api_id" {
  value       = aws_apigatewayv2_api.api.id
  description = "ID of the API Gateway"
}

output "api_execution_arn" {
  value       = aws_apigatewayv2_api.api.execution_arn
  description = "Execution ARN for permissions (used in Lambda permissions)"
}

output "api_endpoint" {
  value       = aws_apigatewayv2_api.api.api_endpoint
  description = "Invoke URL of the API Gateway"
}

output "authorizer_id" {
  value       = aws_apigatewayv2_authorizer.auth0_authorizer.id
  description = "JWT Authorizer ID for secured routes"
}

output "route_id" {
  value       = aws_apigatewayv2_route.lambda_route.id
  description = "ID of the Lambda integration route"
}

output "stage_name" {
  value       = aws_apigatewayv2_stage.api_stage.name
  description = "Stage name of the deployed API"
}
