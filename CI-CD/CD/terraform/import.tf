import {
  to = aws_vpc.dotnet
  id = var.vpc_id
}

resource "aws_vpc" "dotnet" {}

data "aws_subnet" "public" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.dotnet.id]
  }

  tags = {
    Tier = "Public"
    AZ = "a"
  }
}

data "aws_subnet" "private-a" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.dotnet.id]
  }

  tags = {
    Tier = "Private"
    AZ = "a"
  }
}

data "aws_subnet" "private-b" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.dotnet.id]
  }

  tags = {
    Tier = "Private"
    AZ = "b"
  }
}


