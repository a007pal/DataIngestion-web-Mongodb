output "api_endpoint" {
  value = module.apigateway.api_endpoint
  description = "Invoke URL of the API Gateway"
}
output "lambda_function_arn" {
  value = module.lambda_producer.lambda_function_arn
  description = "ARN of the Lambda function"
}
output "secrets_name" {
  value = module.secretsmanager.zk_tls_secret_names
  description = "List of Zookeeper TLS secret names"
  
}
output "bastion_public_ip" {
  value = module.bastion.bastion_public_ip
  description = "Public IP of the bastion host for SSH access"
  
}