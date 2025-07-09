variable "zk_instance_count" {
  description = "Number of Zookeeper instances to deploy"
  type        = number
}
variable "broker_instance_count" {
  description = "Number of Zookeeper instances to deploy"
  type        = number
}
variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}
variable "zookeer_secret_name_prefix" {
  description = "Prefix for Zookeeper secret names"
  type        = string
  default     = "zk-tls-node"
}
variable "broker_secret_name_prefix" {
  description = "Prefix for Zookeeper secret names"
  type        = string
  default     = "broker-node"
}
variable "environment" {
  description = "Environment for the deployment (e.g., dev, prod)"
  type        = string

}
variable "certs_path_zookeeper" {
  description = "Path to the directory containing Zookeeper TLS certificates"
  type        = string

}
variable "certs_path_broker" {
  description = "Path to the directory containing Zookeeper TLS certificates"
  type        = string

}
