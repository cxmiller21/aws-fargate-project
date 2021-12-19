variable "service_name" {
    type = string
}

variable "container_name" {
    type = string
}

variable "container_port" {
    type = number
}

variable "container_definitions" {
    type = string
}

variable "execution_role_arn" {
    type = string
}

variable "cluster_name" {
    type = string
}

variable "desired_count" {
    type = number
    default = 1
}

variable "aws_lb_target_group_arn" {
    type = string
}