resource "aws_route_table" "private_az1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_az1.id
  }

  tags = {
    Name = "production-3tier-private-rt-az1"
  }
}

resource "aws_route_table" "private_az2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_az2.id
  }

  tags = {
    Name = "production-3tier-private-rt-az2"
  }
}

resource "aws_route_table_association" "frontend_az1" {
  subnet_id      = aws_subnet.subnets["frontend_az1"].id
  route_table_id = aws_route_table.private_az1.id
}

resource "aws_route_table_association" "frontend_az2" {
  subnet_id      = aws_subnet.subnets["frontend_az2"].id
  route_table_id = aws_route_table.private_az2.id
}

resource "aws_route_table_association" "backend_az1" {
  subnet_id      = aws_subnet.subnets["backend_az1"].id
  route_table_id = aws_route_table.private_az2.id
}

resource "aws_route_table_association" "backend_az2" {
  subnet_id      = aws_subnet.subnets["backend_az2"].id
  route_table_id = aws_route_table.private_az2.id
}