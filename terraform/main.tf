module "network" {
  source             = "./modules/network"
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  az                 = var.az
  region             = var.region
  tags               = { project = "fiap-aws-vm" }
}


module "vm" {
  source             = "./modules/vm"
  name               = "fiap-web"
  ami                = var.ami
  instance_type      = var.instance_type
  subnet_id          = module.network.public_subnet_id
  security_group_ids = [module.network.sg_public_id]
  user_data_path     = var.user_data_path
  tags               = { project = "fiap-aws-vm" }
}

provider "aws" {
  region = var.region
}

