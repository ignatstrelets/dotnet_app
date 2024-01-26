resource "aws_vpc_endpoint" "secrets_manager_endpoint" {
  service_name = var.sm_endpoint_service_name
  vpc_id       = var.vpc_id
  subnet_ids = [data.aws_subnet.public.id]
  security_group_ids = [aws_security_group.dotnet-app-sg.id]
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
}