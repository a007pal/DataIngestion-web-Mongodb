variable "zookeeper_count" { default = 3 }
variable "ami_id" {}
variable "instance_type" {}
variable "subnet_ids" { type = list(string) }
variable "key_name" {}
variable "sg_id" {}
variable "tags" { type = map(string) }
variable "keystore_password" {}
variable "truststore_password" {}