resource "aws_security_group" "dotnet-rds-sg" {
  name = "dotnet-rds-sg"
  vpc_id = data.aws_vpc.dotnet.id
}

resource "aws_security_group_rule" "ingress_postgres" {
  from_port         = 5432
  protocol          = "tcp"
  security_group_id = aws_security_group.dotnet-rds-sg.id
  to_port           = 5432
  type              = "ingress"
  source_security_group_id = aws_security_group.dotnet-app-sg.id
}

resource "aws_db_subnet_group" "db-sub-gr" {
  name = "db-sub-gr"
  subnet_ids = [data.aws_subnet.private-a.id, data.aws_subnet.private-b.id]
}

resource "aws_db_instance" "postgres" {
  identifier = "dotnet-psql"
  instance_class = "db.t3.micro"
  engine = "postgres"
  engine_version = "14.10"
  db_subnet_group_name = aws_db_subnet_group.db-sub-gr.name
  vpc_security_group_ids = [aws_security_group.dotnet-rds-sg.id]
  availability_zone = "eu-north-1a"
  storage_type = "gp2"
  allocated_storage = 10
  port = 5432
  username = var.db_username
  password = var.db_password
  backup_retention_period = 7
  skip_final_snapshot = true
}
















