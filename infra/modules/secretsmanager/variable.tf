variable "zk_instance_count" {
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
variable "environment" {
  description = "Environment for the deployment (e.g., dev, prod)"
  type        = string

}
variable "certs_path" {
  description = "Path to the directory containing Zookeeper TLS certificates"
  type        = string

}
