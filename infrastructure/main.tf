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
# ECS Cluster Resources
####################################################################
variable "cluster_name" {
    type = string
    default = "aws-fargate-project"
}

resource "aws_kms_key" "demo" {
  description             = "demo key for ECS cluster logging"
  deletion_window_in_days = 7
}

resource "aws_cloudwatch_log_group" "cluster" {
  name = "ecs-cluster-${var.cluster_name}"
}

resource "aws_ecs_cluster" "demo" {
  name = var.cluster_name

  # collect, aggregate, and summarize metrics and logs from running containers
  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.demo.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.cluster.name
      }
    }
  }
}

####################################################################
# ECR Repo (push the frontend and backend docker images here)
####################################################################
resource "aws_ecr_repository" "main" {
  name                 = var.fargate_project_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}