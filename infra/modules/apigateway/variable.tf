variable "environment" {
  description = "Environment for the API Gateway (e.g., dev, prod)"
  type        = string
  default     = "dev"

}
variable "audience" {
  description = "Audience for the JWT authorizer"
  type        = string

}
variable "issuer" {
  description = "Issuer for the JWT authorizer"
  type        = string
}
variable "tags" {
  description = "Tags to apply to the API Gateway"
  type        = string

}
variable "lambda_function_name_arn" {
  description = "Name of the Lambda function to be integrated with API Gateway"
  type        = string

}
variable "lambda_invoke_arn" {
  description = "ARN of the Lambda function to be invoked by API Gateway"
  type        = string

}
variable "funtion_name" {
  description = "Name of the function for API Gateway"
  type        = string

}
