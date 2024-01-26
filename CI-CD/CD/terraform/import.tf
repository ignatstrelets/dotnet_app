data "aws_vpc" "dotnet" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_subnet" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.dotnet.id]
  }

  tags = {
    Tier = "Public"
    AZ = "a"
  }
}

data "aws_subnet" "private-a" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.dotnet.id]
  }

  tags = {
    Tier = "Private"
    AZ = "a"
  }
}

data "aws_subnet" "private-b" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.dotnet.id]
  }

  tags = {
    Tier = "Private"
    AZ = "b"
  }
}



