resource "aws_security_group" "dotnet-elb-sg" {
  name = "dotnet-elb-sg"
  vpc_id = data.aws_vpc.dotnet.id
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "egress_http" {
  from_port         = 8000
  protocol          = "tcp"
  security_group_id = aws_security_group.dotnet-elb-sg.id
  to_port           = 8000
  type              = "egress"
  source_security_group_id = aws_security_group.dotnet-app-sg.id
}

resource "aws_elb" "elb" {
  name               = "dotnet-elb"
  subnets = [data.aws_subnet.public.id]
  cross_zone_load_balancing = true
  idle_timeout = 60
  connection_draining = true
  security_groups = [aws_security_group.dotnet-elb-sg.id]
  listener {
    instance_port     = 8000
    instance_protocol = "tcp"
    lb_port           = 80
    lb_protocol       = "tcp"
  }
  health_check {
    healthy_threshold   = 10
    unhealthy_threshold = 2
    timeout             = 4
    target              = "HTTP:8000/"
    interval            = 5
  }
}






