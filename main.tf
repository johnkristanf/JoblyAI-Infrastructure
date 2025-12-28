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
  profile = var.profile
}

module "network" {
  source = "./modules/network"
  ec2_instance_id = module.compute.ec2_instance_id
}

module "identity_compliance" {
  source = "./modules/identity_compliance"
  bucket_name = "joblyai-production-bucket"
}

module "object_storage" {
  source = "./modules/object_storage"
  environment = "production"
  bucket_name = "joblyai-production-bucket"
}

module "compute" {
  source           = "./modules/compute"
  environment      = "production"
  instance_type = "t3.micro"
  
  ec2_security_group_id = module.network.ec2_security_group_id

  private_subnet_id = module.network.private_subnet_id
  public_subnet_id = module.network.public_subnet_id

  ec2_profile_name = module.identity_compliance.ec2_profile_name
}

module "integration" {
  source = "./modules/integration"
  environment      = "production"
  alb_security_group_id = module.network.alb_security_group_id
  private_subnet_id = module.network.private_subnet_id
  alb_http_listener_arn = module.network.alb_http_listener_arn 
}