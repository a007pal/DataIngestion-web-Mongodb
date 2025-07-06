variable "region" {
  default = "ap-south-1"
}
variable "name_prefix" {}
variable "vpc_cidr" {}
variable "azs" { type = list(string) }
variable "tags" { type = map(string) }

variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}

variable "zookeeper_count" {}
variable "broker_count" {}
variable "min_insync_replicas" {}

variable "keystore_password" {}
variable "truststore_password" {}

/* variable "sg_zookeeper" {}
variable "sg_kafka" {}
variable "sg_schema_registry" {}
variable "sg_lambda" {}
variable "sg_monitoring" {} */

variable "lambda_function_name" {}
variable "environment" {}
variable "sasl_secret_arn" {}
variable "tls_secret_arn" {}

variable "api_gateway_name" {}
variable "auth0_audience" {}
variable "auth0_issuer" {}

variable "public_subnet_cidrs" {
  type = list(string)
}
variable "private_subnet_cidrs" {
  type = list(string)
}