
resource "aws_vpc" "app_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = var.vpcName
    Env  = var.environment
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.app_vpc.id
  tags = {
    Name = "Internet GW"
    Env  = var.environment
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "2nd Route Table",
    Env  = var.environment
  }

  depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Public Subnet - 1"
    Env  = var.environment
  }

  depends_on = [aws_route_table.public_rt]
}

resource "aws_route_table_association" "public_subnet_asso" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_eip" "eip" {
  domain = "vpc"
  tags = {
    Name = "elastic ip"
    Env  = var.environment
  }
}

resource "aws_nat_gateway" "pub_nat_gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "Public NGW - 1"
    Env  = var.environment
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.internet_gateway]
}


resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "Prv Route Table",
    Env  = var.environment
  }

}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = "10.0.1.0/24"


  tags = {
    Name = "Private Subnet - 1"
    Env  = var.environment
  }
}

resource "aws_route_table_association" "private_subnet_asso" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route" "nat_to_igw" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.pub_nat_gw.id
}
