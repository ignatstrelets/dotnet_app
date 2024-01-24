resource "aws_security_group" "dotnet-loki-sg" {
  name = "dotnet-elb-sg"
  vpc_id = aws_vpc.dotnet.id
}

resource "aws_security_group_rule" "ingress_loki_http" {
  from_port         = 3100
  protocol          = "http"
  security_group_id = aws_security_group.dotnet-loki-sg.id
  to_port           = 3100
  type              = "ingress"
  source_security_group_id = aws_security_group.dotnet-app-sg.id
}

resource "aws_security_group_rule" "ingress_grafana_http" {
  from_port         = 3000
  protocol          = "http"
  security_group_id = aws_security_group.dotnet-loki-sg.id
  to_port           = 3000
  type              = "ingress"
  cidr_blocks = ["89.232.40.100/32"]
}

resource "aws_instance" "loki" {
  ami           = "ami-00bad1a01230aaace"
  instance_type = "t3.micro"
  subnet_id = data.aws_subnet.private-a.id
  private_ip = "10.0.1.1"
}

