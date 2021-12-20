variable "service_name" {
    type = string
}

variable "container_name" {
    type = string
}

variable "container_port" {
    type = number
}

variable "execution_role_arn" {
    type = string
}

variable "cluster_arn" {
    type = string
}

variable "desired_count" {
    type = number
    default = 1
}

variable "aws_lb_target_group_arn" {
    type = string
}

variable "ecr_image_tag" {
    type = string
}