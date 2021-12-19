resource "aws_ecs_service" "main" {
  name            = var.service_name
  cluster         = var.cluster_name
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = var.desired_count
  iam_role        = var.iam_role

  load_balancer {
    target_group_arn = var.aws_lb_target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }
}

resource "aws_ecs_task_definition" "main" {
  family                   = "${var.service_name}-aws-fargate-project"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512

  container_definitions = var.container_definitions
  execution_role_arn = var.execution_role_arn
}
