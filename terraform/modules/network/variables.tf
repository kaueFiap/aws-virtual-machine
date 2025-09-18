variable "vpc_cidr" {}
variable "public_subnet_cidr" {}
variable "az" {}
variable "region" {}
variable "tags" {
  type = map(string)
}
