variable "server_service_name" {
  type    = string
  default = "node-server"
}

variable "server_ecr_identifier" {
  type    = string
  default = "server"
}

module "server_service" {
  source = "./modules/ecs/service"

  # ECS Service Variables
  service_name            = var.server_service_name
  cluster_arn             = module.cluster.cluster_arn
  ecs_task_definition_arn = module.server_task_definition.task_arn
  desired_count           = 1
  subnets                 = [aws_subnet.public.id]

  # Security Group Variables
  vpc_id                 = aws_vpc.main.id
  inbound_container_port = 3000
}

module "server_task_definition" {
  source = "./modules/ecs/task-definition"

  # AWS Variables
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name

  # Task Definition Variables
  task_definition_family = var.server_service_name
  host_port              = 3000
  container_port         = 3000
  ecr_repo               = "${var.fargate_project_name}-${var.server_ecr_identifier}"
  ecr_image_tag          = var.server_ecr_identifier
  execution_role_arn     = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"
}