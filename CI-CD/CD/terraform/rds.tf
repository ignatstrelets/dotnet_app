resource "aws_security_group" "dotnet-rds-sg" {
  name = "dotnet-rds-sg"
  vpc_id = aws_vpc.dotnet.id
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

resource "aws_rds_cluster" "default" {
  cluster_identifier      = "dotnet-psql"
  availability_zones      = ["eu-north-1a", "eu-north-1b"]
  database_name           = "dotnet-psql"
  master_username         = var.db_username
  master_password         = var.db_password
  backup_retention_period = 5
  allocated_storage = 10
  db_subnet_group_name = aws_db_subnet_group.db-sub-gr.name
}

resource "aws_rds_cluster_instance" "postgres" {
  cluster_identifier = aws_rds_cluster.default.cluster_identifier
  instance_class = "db.t3.micro"
  vpc_security_group_ids = [aws_security_group.dotnet-rds-sg.id]
  engine = "postgres"
  engine_version = "14.10"
}
