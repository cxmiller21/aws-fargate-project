variable "cluster_name" {
    type = string
}

resource "aws_kms_key" "main" {
  description             = "ECS '${var.cluster_name}' cluster logging Key"
  deletion_window_in_days = 7
}

resource "aws_cloudwatch_log_group" "cluster" {
  name = "/aws/ecs/cluster/${var.cluster_name}"
}

resource "aws_ecs_cluster" "main" {
  name = var.cluster_name

  # collect, aggregate, and summarize metrics and logs from running containers
  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.main.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.cluster.name
      }
    }
  }
}

output "cluster_arn" {
    value = aws_ecs_cluster.main.arn
}
