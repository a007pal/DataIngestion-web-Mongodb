variable "name_prefix" {}
variable "vpc_cidr" {}
variable "azs" {
  type = list(string)
}
variable "public_subnet_cidrs" {
  type = list(string)
}
variable "private_subnet_cidrs" {
  type = list(string)
}
variable "tags" {
  type = map(string)
}
variable "allowed_ssh_cidr_bastion" {}
variable "region" {}