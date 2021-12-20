variable "vpc_id" {
    type = string
}

variable "inbound_container_port" {
  type = number
  default = 80
}

resource "aws_security_group" "main" {
  name        = "ecs-service-${var.service_name}-sg"
  description = "Security group for ECS Service ${var.service_name}"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "default" {
  security_group_id = aws_security_group.main.id
  type              = "ingress"
  from_port         = var.inbound_container_port
  to_port           = var.inbound_container_port
  protocol          = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "egress" {
  security_group_id = aws_security_group.main.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
}

output "security_group_id" {
    value = aws_security_group.main.id 
}
