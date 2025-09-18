output "ec2_public_url" {
  value = "http://${module.vm.ec2_public_dns}"
}

