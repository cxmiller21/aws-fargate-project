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

####################################################################
# VPC + Subnets
####################################################################
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "aws-fargate-project-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_1_cidr
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    "Name" = "public-subnet-1"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "VPC-IGW"
  }
}

resource "aws_route" "vpc_igw_route" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.main.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "public-route-table"
  }
}
