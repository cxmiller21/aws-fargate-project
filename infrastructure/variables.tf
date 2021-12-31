variable "fargate_project_name" {
  type    = string
  default = "aws-fargate-project"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  default = "10.0.1.0/24"
}
