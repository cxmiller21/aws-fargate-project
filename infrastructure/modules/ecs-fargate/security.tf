variable "vpc_id" {
    type = string
}

variable "sg_container_port" {
  type = number
  default = 80
}

variable "enable_inbound_sg_access" {
  type = bool
  default = false
}

variable "ingress_sg_id" {
  type = string
  default = ""
}

resource "aws_security_group" "main" {
  name        = "ecs-service-${var.service_name}-sg"
  description = "Security group for ECS Service ${var.service_name}"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "default" {
  count = !var.enable_inbound_sg_access ? 1 : 0
  security_group_id = aws_security_group.main.id
  type              = "ingress"
  from_port         = var.container_port
  to_port           = var.container_port
  protocol          = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress_sg" {
  count = var.enable_inbound_sg_access ? 1 : 0
  security_group_id = aws_security_group.main.id
  type              = "ingress"
  from_port         = var.container_port
  to_port           = var.container_port
  protocol          = "tcp"
  source_security_group_id = var.ingress_sg_id
}

resource "aws_security_group_rule" "egress" {
  security_group_id = aws_security_group.main.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
}
