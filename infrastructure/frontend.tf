module "frontend" {
    source = "./modules/ecs-fargate"

    account_id = data.aws_caller_identity.current.account_id
    region = data.aws_region.current.name

    ecr_image_tag = "frontend"

    aws_lb_target_group_arn = "taco"
    execution_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"

    vpc_id = var.vpc_id
    subnets = [ var.subnet_id ]

    cluster_arn = "arn:aws:ecs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cluster/${aws_ecs_cluster.demo.name}"
    service_name = "vue-frontend"
    container_name = "vue-frontend"
    container_port = 80
}