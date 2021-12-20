variable "service_name" {
    type = string
}

variable "cluster_arn" {
    type = string
}

variable "ecs_task_definition_arn" {
    type = string
}

variable "desired_count" {
    type = number
}

variable "subnets" {
    type = list(string)
}

resource "aws_ecs_service" "main" {
  name            = var.service_name
  cluster         = var.cluster_arn
  task_definition = var.ecs_task_definition_arn
  desired_count   = var.desired_count

  // iam_role = "aws-service-role"
  launch_type = "FARGATE"

  enable_ecs_managed_tags = true

  /*
  load_balancer {
    target_group_arn = var.aws_lb_target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }
  */

  deployment_circuit_breaker {
    enable = false
    rollback = false
  }

  deployment_controller {
    type = "ECS"
  }

  network_configuration {
    assign_public_ip = true
    security_groups = [aws_security_group.main.id]
    subnets = var.subnets
  }

}
