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
resource "aws_kms_key" "demo" {
  description             = "demo key for ECS cluster logging"
  deletion_window_in_days = 7
}

resource "aws_cloudwatch_log_group" "cluster" {
  name = "${var.cluster_name}-logs"
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
