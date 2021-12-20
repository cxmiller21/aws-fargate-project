variable "task_definition_family" {
  type = string
}

variable "region" {
  type = string
}

variable "host_port" {
  type = number
}

variable "container_port" {
  type = number
}

variable "container_env_variables" {
  type = any
  default = null
}

variable "account_id" {
  type = string
}

variable "ecr_repo" {
  type = string
}

variable "ecr_image_tag" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

resource "aws_cloudwatch_log_group" "task_definition" {
  name = "/aws/ecs/task-definition/${var.task_definition_family}"
}

resource "aws_ecs_task_definition" "main" {
  family                   = var.task_definition_family
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
          "awslogs-group": "${aws_cloudwatch_log_group.task_definition.name}",
          "awslogs-region": "${var.region}",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "portMappings": [
        {
          "hostPort": "${var.host_port}",
          "protocol": "tcp",
          "containerPort": "${var.container_port}"
        }
      ],
      "image": "${var.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.ecr_repo}:latest",
      "name": "${var.ecr_image_tag}"
    }
  ])

  execution_role_arn = var.execution_role_arn

  runtime_platform {
    operating_system_family = "LINUX"
  }
}

output "task_arn" {
  value = aws_ecs_task_definition.main.arn
}
