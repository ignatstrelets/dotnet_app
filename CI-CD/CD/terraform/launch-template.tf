resource "aws_security_group" "dotnet-app-sg" {
  name = "dotnet-app-sg"
  vpc_id = aws_vpc.dotnet.id

  ingress {
    from_port        = 8000
    to_port          = 8000
    protocol         = "tcp"
    security_groups = [aws_security_group.dotnet-elb-sg.id]
  }

  egress {
    from_port = 3100
    to_port = 3100
    protocol = "tcp"
    security_groups = [aws_security_group.dotnet-loki-sg.id]
  }
}

resource "aws_launch_template" "ubuntu-dotnet-promtail" {
  image_id = "ami-066fc4eb1b13a2500"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.dotnet-app-sg.id]
}