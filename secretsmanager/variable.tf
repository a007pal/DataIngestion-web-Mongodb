variable "zk_instance_count" {
  description = "Number of Zookeeper instances to deploy"
  type        = number
  default     = 3
}
variable "broker_instance_count" {
  description = "Number of Zookeeper instances to deploy"
  type        = number
  default     = 3
}
variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default = "property-view-tracker"
}
variable "zookeer_secret_name_prefix" {
  description = "Prefix for Zookeeper secret names"
  type        = string
  default     = "zookeeper_tls"
}
variable "broker_secret_name_prefix" {
  description = "Prefix for Zookeeper secret names"
  type        = string
  default     = "kafka_tls"
}
variable "environment" {
  description = "Environment for the deployment (e.g., dev, prod)"
  type        = string
  default     = "dev"

}
variable "certs_path_zookeeper" {
  description = "Path to the directory containing Zookeeper TLS certificates"
  type        = string
  default     = "../certs/zookeeper"

}
variable "certs_path_broker" {
  description = "Path to the directory containing Zookeeper TLS certificates"
  type        = string
  default     = "../certs/kafka"

}
variable "region" {
  description = "secrets manger region"
  type = string
  default = "ap-south-1"
}