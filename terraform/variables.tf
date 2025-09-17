variable "region" { type = string }
variable "tf_state_bucket" { type = string }
variable "tf_state_lock_table" {
  type    = string
  default = ""
}

# parâmetros de infra
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}
variable "az" {
  type    = string
  default = "us-east-1a"
}

variable "ami" {
  type    = string
  default = "ami-0c101f26f147fa7fd"
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "user_data_path" {
  type    = string
  default = "scripts/user_data.sh"
}
