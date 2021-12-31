variable "client_service_name" {
  type    = string
  default = "vue-client"
}

variable "client_ecr_identifier" {
  type    = string
  default = "client"
}

variable "node_task_ip_address_updated" {
  type    = bool
  default = true
}

module "client_service" {
  count  = var.node_task_ip_address_updated ? 1 : 0
  source = "./modules/ecs/service"

  # ECS Service Variables
  service_name            = var.client_service_name
  cluster_arn             = module.cluster.cluster_arn
  ecs_task_definition_arn = module.client_task_definition[0].task_arn
  desired_count           = 1
  subnets                 = [aws_subnet.public.id]

  # Security Group Variables
  vpc_id                 = aws_vpc.main.id
  inbound_container_port = 80
}

module "client_task_definition" {
  count  = var.node_task_ip_address_updated ? 1 : 0
  source = "./modules/ecs/task-definition"

  # AWS Variables
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name

  # Task Definition Variables
  task_definition_family = var.client_service_name
  host_port              = 80
  container_port         = 80
  ecr_repo               = "${var.fargate_project_name}-${var.client_ecr_identifier}"
  ecr_image_tag          = var.client_ecr_identifier
  execution_role_arn     = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"
}