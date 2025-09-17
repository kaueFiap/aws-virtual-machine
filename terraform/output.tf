output "ec2_public_url" {
  value       = "http://${aws_instance.instance.public_dns}"
  description = "URL público da instância EC2"
}
