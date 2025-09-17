variable "vpc_cidr" { type = string }
variable "public_subnet_cidr" { type = string }
variable "az" { type = string }
variable "allow_intra_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "allow_ssh_cidr" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}
variable "allow_http_cidr" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}
variable "tags" {
  type    = map(string)
  default = {}
}
