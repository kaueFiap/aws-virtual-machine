output "vpc_id" { value = aws_vpc.this.id }
output "public_subnet_id" { value = aws_subnet.public.id }
output "sg_public_id" { value = aws_security_group.public.id }
