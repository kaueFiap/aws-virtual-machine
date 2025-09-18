variable "create_iam_role" {
  type    = bool
  default = false
}

resource "aws_iam_role" "ec2_role" {
  count = var.create_iam_role ? 1 : 0

  name = "ec2_instance_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  count = var.create_iam_role ? 1 : 0
  name  = "ec2_instance_profile"
  role  = var.create_iam_role ? aws_iam_role.ec2_role[0].name : null
}

resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  key_name               = var.key_name
  user_data_base64       = base64encode(templatefile(var.user_data_path, {}))
  monitoring             = true
  ebs_optimized          = true
  iam_instance_profile   = var.create_iam_role ? aws_iam_instance_profile.ec2_profile[0].name : null

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    encrypted = true
  }

  tags = merge(var.tags, { Name = var.name })
}
