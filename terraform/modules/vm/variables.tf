variable "ami" {}
variable "instance_type" {}
variable "subnet_id" {}
variable "security_group_ids" {
  type = list(string)
}
variable "key_name" {
  default = null
}
variable "user_data_path" {}
variable "tags" {
  type = map(string)
}
variable "name" {}

