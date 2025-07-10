variable "name_perfix" {
  description = "Prefix for the Route53 zone name"
  type        = string

}
variable "zookeeper_private_ips" {
  description = "values for the zookeper private ips"
  type        = list(string)
}
variable "zookeeper_count" {
  description = "Number of zookeper instances"
  type        = number
  
}
variable "kafka_private_ips" {
  description = "values for the zookeper private ips"
  type        = list(string)
}
variable "kafka_count" {
  description = "Number of zookeper instances"
  type        = number
  
}
variable "vpc_id" {
  description = "VPC ID where the Route53 zone will be created"
  type        = string
  
}
variable "environment" {
  description = "Environment for the Route53 zone"
  type        = string
  
}