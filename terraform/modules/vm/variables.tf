variable "name" { type = string }
variable "ami" { type = string }
variable "instance_type" { type = string }
variable "subnet_id" { type = string }
variable "security_group_ids" { type = list(string) }
variable "user_data_path" { type = string } # caminho do script
variable "tags" {
  type    = map(string)
  default = {}
}
variable "key_name" {
  type    = string
  default = null
}
