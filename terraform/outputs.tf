output "api_endpoint" {
  description = "The API endpoint for the deployed application"
  value       = aws_apigatewayv2_api.api.api_endpoint
  
}

