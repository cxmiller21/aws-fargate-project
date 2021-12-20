####################################################################
# Initilazation Settings
####################################################################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 1"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

####################################################################
# ECS Cluster
####################################################################
module "cluster" {
  source       = "./modules/ecs/cluster"
  cluster_name = var.fargate_project_name
}

####################################################################
# ECR Repos (push the client and server docker images)
####################################################################
variable "ecr_repos" {
  type    = set(string)
  default = ["client", "server"]
}

resource "aws_ecr_repository" "main" {
  for_each             = var.ecr_repos
  name                 = "${var.fargate_project_name}-${each.value}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}