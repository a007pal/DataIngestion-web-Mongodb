variable "ami_id" {}
variable "instance_type" {}
variable "subnet_id" {}
variable "key_name" {}
variable "sg_id" {}
variable "bootstrap_servers" {}
variable "tags" { type = map(string) }