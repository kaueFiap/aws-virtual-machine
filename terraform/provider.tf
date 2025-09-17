terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.11.0"
    }
  }

  backend "s3" {
    bucket  = "aws-bucket-17-9-2025"
    key     = "aws-virtual-machine/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
