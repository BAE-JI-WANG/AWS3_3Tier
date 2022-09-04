# VPC
resource "aws_vpc" "awesome-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "awesome-vpc"
  }
}

# IGW
resource "aws_internet_gateway" "awesome-ap2-igw" {
  vpc_id = aws_vpc.awesome-vpc.id

  tags = {
    Name = "awesome-ap2-igw"
  }
}

# NAT
resource "aws_nat_gateway" "awesome-ap2-nat" {
  allocation_id = aws_eip.awesome-ap2-nat-eip.id

  subnet_id = aws_subnet.awesome-ap-pub-sub-2a.id

  tags = {
    Name = "awesome-ap2-nat"
  }
}

# Subnet Ids
# data "aws_subnet_ids" "awesome_public_subnets" {
#   vpc_id = aws_vpc.awesome-vpc.id
# }

# Route Table
resource "aws_route_table" "awesome-ap2-pub-rt" {
  vpc_id = aws_vpc.awesome-vpc.id

  tags = {
    Name = "awesome-ap2-pub-rt"
  }
}

resource "aws_route_table" "awesome-ap2-pri-rt" {
  vpc_id = aws_vpc.awesome-vpc.id

  tags = {
    Name = "awesome-ap2-pri-rt"
  }
}

# Route Table Association A
resource "aws_route_table_association" "awesome-ap2-pub-rt-ass-a" {
  subnet_id = aws_subnet.awesome-ap-pub-sub-2a.id
  route_table_id = aws_route_table.awesome-ap2-pub-rt.id
}

resource "aws_route_table_association" "awesome-ap2-web-rt-ass-a" {
  subnet_id = aws_subnet.awesome-ap-web-sub-2a.id
  route_table_id = aws_route_table.awesome-ap2-pri-rt.id
}

resource "aws_route_table_association" "awesome-ap2-was-rt-ass-a" {
  subnet_id = aws_subnet.awesome-ap-was-sub-2a.id
  route_table_id = aws_route_table.awesome-ap2-pri-rt.id
}

resource "aws_route_table_association" "awesome-ap2-db-rt-ass-a" {
  subnet_id = aws_subnet.awesome-ap-db-sub-2a.id
  route_table_id = aws_route_table.awesome-ap2-pri-rt.id
}

resource "aws_route_table_association" "awesome-ap2-web-efs-rt-ass-a" {
  subnet_id = aws_subnet.awesome-ap-web-efs-sub-2a.id
  route_table_id = aws_route_table.awesome-ap2-pri-rt.id
}

resource "aws_route_table_association" "awesome-ap2-was-efs-rt-ass-a" {
  subnet_id = aws_subnet.awesome-ap-was-efs-sub-2a.id
  route_table_id = aws_route_table.awesome-ap2-pri-rt.id
}

# Route Table Association C
resource "aws_route_table_association" "awesome-ap2-pub-rt-ass-c" {
  subnet_id = aws_subnet.awesome-ap-pub-sub-2c.id
  route_table_id = aws_route_table.awesome-ap2-pub-rt.id
}

resource "aws_route_table_association" "awesome-ap2-web-rt-ass-c" {
  subnet_id = aws_subnet.awesome-ap-web-sub-2c.id
  route_table_id = aws_route_table.awesome-ap2-pri-rt.id
}

resource "aws_route_table_association" "awesome-ap2-was-rt-ass-c" {
  subnet_id = aws_subnet.awesome-ap-was-sub-2c.id
  route_table_id = aws_route_table.awesome-ap2-pri-rt.id
}

resource "aws_route_table_association" "awesome-ap2-db-rt-ass-c" {
  subnet_id = aws_subnet.awesome-ap-db-sub-2c.id
  route_table_id = aws_route_table.awesome-ap2-pri-rt.id
}

resource "aws_route_table_association" "awesome-ap2-web-efs-rt-ass-c" {
  subnet_id = aws_subnet.awesome-ap-web-efs-sub-2c.id
  route_table_id = aws_route_table.awesome-ap2-pri-rt.id
}

resource "aws_route_table_association" "awesome-ap2-was-efs-rt-ass-c" {
  subnet_id = aws_subnet.awesome-ap-was-efs-sub-2c.id
  route_table_id = aws_route_table.awesome-ap2-pri-rt.id
}


resource "aws_route" "awesome-ap2-pri-route" {
  route_table_id              = aws_route_table.awesome-ap2-pri-rt.id
  destination_cidr_block      = "0.0.0.0/0"
  nat_gateway_id              = aws_nat_gateway.awesome-ap2-nat.id
}