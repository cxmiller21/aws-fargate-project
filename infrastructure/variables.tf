variable "fargate_project_name" {
    type = string
    default = "aws-fargate-project"
}

variable "vpc_id" {
    type = string
    default = "vpc-"
}

variable "subnet_id" {
    type = string
    default = "subnet-"
}
