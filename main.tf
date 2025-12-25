terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "network" {
  source = "./modules/network"
  vpc_cidr_block = "10.0.0.0/16"
  public_subnet_cidr_block = "10.0.1.0/24"
  private_subnet_cidr_block = "10.0.11.0/24"
  availability_zone = "ap-southeast-1a"
  ec2_instance_id = module.compute.ec2_instance_id
}

module "compute" {
  source           = "./modules/compute"
  environment      = "production"
  api_versions     = ["/api/v1", "/api/v2"]
  backend_endpoint = "http://example-backend:8080"
  instance_type = "t2-micro"
  
  ec2_security_group_id = module.network.ec2_security_group_id
  private_subnet_id = module.network.private_subnet_id
  public_subnet_id = module.network.public_subnet_id
}

module "integration" {
  source = "./modules/integration"
  environment      = "production"
  alb_security_group_id = module.network.alb_security_group_id
  private_subnet_id = module.network.private_subnet_id
  alb_dns_name = module.network.alb_dns_name
}