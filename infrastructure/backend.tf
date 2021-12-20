variable "node_container_port" {
  type = number
  default = 3000
}

module "backend" {
    source = "./modules/ecs-fargate"

    account_id = data.aws_caller_identity.current.account_id
    region = data.aws_region.current.name

    ecr_image_tag = "backend"
    enable_inbound_sg_access = true
    ingress_sg_id = module.frontend.security_group_id

    aws_lb_target_group_arn = "taco"
    execution_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"

    vpc_id = var.vpc_id
    subnets = [ var.subnet_id ]

    cluster_arn = "arn:aws:ecs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cluster/${aws_ecs_cluster.demo.name}"
    service_name = "node-backend"
    container_name = "node-backend"
    container_port = var.node_container_port
    sg_container_port = var.node_container_port
}