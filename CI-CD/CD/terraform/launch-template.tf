resource "aws_security_group" "dotnet-app-sg" {
  name = "dotnet-app-sg"
  vpc_id = data.aws_vpc.dotnet.id
}

resource "aws_security_group_rule" "my_ip_ssh_ingress" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.dotnet-app-sg.id
  to_port           = 22
  type              = "ingress"
  cidr_blocks = [var.my_ip_cidr_block]
}

resource "aws_security_group_rule" "self_tls_ingress" {
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.dotnet-app-sg.id
  to_port           = 443
  type              = "ingress"
  source_security_group_id = aws_security_group.dotnet-app-sg.id
}

resource "aws_security_group_rule" "tcp_8000_ingress" {
  from_port         = 8000
  protocol          = "tcp"
  security_group_id = aws_security_group.dotnet-app-sg.id
  to_port           = 8000
  type              = "ingress"
  source_security_group_id = aws_security_group.dotnet-elb-sg.id
}

resource "aws_security_group_rule" "self_tls_egress" {
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.dotnet-app-sg.id
  to_port           = 443
  type              = "egress"
  source_security_group_id = aws_security_group.dotnet-app-sg.id
}

resource "aws_security_group_rule" "s3_access_egress" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.dotnet-app-sg.id
  to_port           = 0
  type              = "egress"
  prefix_list_ids = [var.s3_endpoint_prefix_list]
}

resource "aws_security_group_rule" "loki_log_stream_egress" {
  from_port         = 3100
  protocol          = "tcp"
  security_group_id = aws_security_group.dotnet-app-sg.id
  to_port           = 3100
  type              = "egress"
  source_security_group_id = aws_security_group.dotnet-loki-sg.id
}

resource "aws_security_group_rule" "postgres_egress" {
  from_port         = 5432
  protocol          = "tcp"
  security_group_id = aws_security_group.dotnet-app-sg.id
  to_port           = 5432
  type              = "egress"
  source_security_group_id = aws_security_group.dotnet-rds-sg.id
}

resource "aws_launch_template" "ubuntu-dotnet-promtail" {
  image_id = var.app_server_ami_id
  instance_type = "t3.micro"
  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.dotnet-app-sg.id]
  }
  iam_instance_profile {
    name = var.app_server_iam_role_name
  }
  user_data = filebase64("${path.module}/deploy.sh")
  key_name = var.app_server_ssh_key_name
}








