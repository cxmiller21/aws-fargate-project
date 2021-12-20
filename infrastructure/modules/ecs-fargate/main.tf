variable "account_id" {
  type = string
}

variable "region" {
  type = string
}

variable "subnets" {
  type = list(string)
}

resource "aws_ecs_service" "main" {
  name            = var.service_name
  cluster         = var.cluster_arn
  task_definition = aws_ecs_task_definition.main.arn
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

resource "aws_ecs_task_definition" "main" {
  family                   = var.service_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512

  container_definitions = jsonencode([
    {
      "logConfiguration": {
        "logDriver": "awslogs",
        "secretOptions": null,
        "options": {
          "awslogs-group": "/ecs/${var.service_name}",
          "awslogs-region": "${var.region}",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "portMappings": [
        {
          "hostPort": "${var.container_port}",
          "protocol": "tcp",
          "containerPort": "${var.container_port}"
        }
      ],
      "image": "${var.account_id}.dkr.ecr.${var.region}.amazonaws.com/aws-fargate-project:${var.ecr_image_tag}",
      "name": "${var.ecr_image_tag}"
    }
  ])

  execution_role_arn = var.execution_role_arn

  runtime_platform {
    operating_system_family = "LINUX"
  }
}
