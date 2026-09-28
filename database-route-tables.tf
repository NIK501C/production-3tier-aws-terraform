resource "aws_route_table" "database_az1" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "production-3tier-database-rt-az1"
  }
}

resource "aws_route_table" "database_az2" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "production-3tier-database-rt-az2"
  }
}

resource "aws_route_table_association" "database_az1" {
  subnet_id      = aws_subnet.subnets["database_az1"].id
  route_table_id = aws_route_table.database_az1.id
}

resource "aws_route_table_association" "database_az2" {
  subnet_id      = aws_subnet.subnets["database_az2"].id
  route_table_id = aws_route_table.database_az2.id
}