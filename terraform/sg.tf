resource "aws_security_group" "ecs_sg" {
  name        = "${local.prefix}-ecs-sg"
  description = "Allow inbound ${var.container_port} to Flask app (${var.environment})"
  vpc_id      = data.aws_vpc.class_vpc.id

  tags = {
    Name = "${local.prefix}-ecs-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_app_port" {
  security_group_id = aws_security_group.ecs_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.container_port
  to_port           = var.container_port
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_out" {
  security_group_id = aws_security_group.ecs_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}