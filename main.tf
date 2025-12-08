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
}

module "compute" {
  source           = "./modules/compute"
  environment      = "production"
  api_versions     = ["/api/v1", "/api/v2"]
  backend_endpoint = "http://example-backend:8080"
}
