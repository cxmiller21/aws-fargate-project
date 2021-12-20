variable "fargate_project_name" {
  type    = string
  default = "aws-fargate-project"
}

# Modify these variables with your VPC and Subnet ID
variable "vpc_id" {
  type    = string
  default = ""
}

variable "subnet_id" {
  type    = string
  default = ""
}
