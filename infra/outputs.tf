output "api_endpoint" {
  description = "The API endpoint for the deployed application"
  value       = aws_apigatewayv2_api.api.api_endpoint
  
}

output "vpc_id" {
  description = "The ID of the VPC created for the Lambda function"
  value       = aws_vpc.lambda_vpc.id
}
output "private_subnet_id" {
  description = "The ID of the private subnet created for the Lambda function"
  value       = aws_subnet.private_subnet.id
  
}
output "lambda_security_group_id" {
  description = "The ID of the security group created for the Lambda function"
  value       = aws_security_group.lambda_sg.id
}