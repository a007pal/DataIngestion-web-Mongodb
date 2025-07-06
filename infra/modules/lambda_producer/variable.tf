variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
  
}
variable "environment" {
  description = "value of environment"
  type        = string
}
variable "sasl_secret_arn" {
  description = "ARN of the SASL secret in Secrets Manager"
  type        = string
  
}
variable "tls_secret_arn" {
  description = "ARN of the TLS secret in Secrets Manager"
  type        = string
  
}
variable "sg_lambda" {
  description = "Security group ID for the Lambda function"
  type        = list(string)
  
}
variable "private_subnet_ids" {
  description = "List of private subnet IDs for the Lambda function"
  type        = list(string)
  
}