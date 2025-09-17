resource "aws_instance" "this" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  key_name                    = var.key_name
  user_data_base64            = base64encode(templatefile(var.user_data_path, {}))
  tags = merge(var.tags, { Name = var.name })
}
