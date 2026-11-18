terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# -------------------------------------------------------------------
# Modulo de rede (Atividade 03)
# -------------------------------------------------------------------
module "network" {
  source = "../../modules/network"

  aws_region      = var.aws_region
  azs             = var.azs
  project_tag     = var.project_name
  environment_tag = var.environment
}

# -------------------------------------------------------------------
# Modulo de compute (Atividade 04)
# vpc_id e subnet_ids vem dos outputs do modulo network
# -------------------------------------------------------------------
module "compute" {
  source = "../../modules/compute"

  vpc_id        = module.network.vpc_id
  subnet_ids    = module.network.private_subnet_ids
  project_name  = var.project_name
  environment   = var.environment
  cpu           = var.cpu
  memory        = var.memory
  desired_count = var.desired_count
  aws_region    = var.aws_region
}
