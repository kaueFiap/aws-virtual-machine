# VPC
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags                 = merge(var.tags, { Name = "vm-vpc" })
}

# Flow Logs para a VPC
resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "/aws/vpc/flow-logs"
  retention_in_days = 7
}

resource "aws_flow_log" "vpc" {
  log_destination      = aws_cloudwatch_log_group.vpc_flow_logs.arn
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.this.id
  log_destination_type = "cloud-watch-logs"
}

# Restringe o SG default da VPC
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.this.id
  ingress = []
  egress  = []
}

# IGW
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "vm-igw" })
}

# Subnet pública (sem IP público automático)
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.az
  map_public_ip_on_launch = false
  tags                    = merge(var.tags, { Name = "vm-public" })
}

# Rota pública
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = merge(var.tags, { Name = "vm-rt-public" })
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security Group
resource "aws_security_group" "public" {
  name        = "sg_public"
  description = "Security group para tráfego público"
  vpc_id      = aws_vpc.this.id

  # Egress seguro apenas para portas necessárias (ex.: HTTP e HTTPS)
  egress {
    description = "Saída HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Saída HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Tráfego interno
  ingress {
    description = "Tráfego interno permitido"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.allow_intra_cidr]
  }

  # SSH
  dynamic "ingress" {
    for_each = var.allow_ssh_cidr
    content {
      description = "Acesso SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  # HTTP
  dynamic "ingress" {
    for_each = var.allow_http_cidr
    content {
      description = "Acesso HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  tags = merge(var.tags, { Name = "sg_public" })
}
