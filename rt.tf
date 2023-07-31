
resource "aws_route_table" "public_route_table" {
  for_each = var.vpcs

  vpc_id = aws_vpc.network[each.key].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[each.key].id
  }

  tags = {
    Name = "Public-Route-Table-${each.key}"
  }
}
resource "aws_eip" "nat_eip" {
  for_each = var.vpcs

  tags = {
    Name = "NAT-Gateway-EIP-${each.key}"
  }
}

resource "aws_nat_gateway" "nat" {
  for_each = var.vpcs

  allocation_id = aws_eip.nat_eip[each.key].id
  subnet_id     = aws_subnet.external_subnet[each.key].id

  tags = {
    Name = "NAT-Gateway-${each.key}"
  }
}

resource "aws_route_table" "private_route_table" {
  for_each = var.vpcs

  vpc_id = aws_vpc.network[each.key].id

  tags = {
    Name = "Private-Route-Table-${each.key}"
  }
}


#Route Table Associations

resource "aws_route_table_association" "public_association" {
  for_each = var.vpcs

  subnet_id      = aws_subnet.external_subnet[each.key].id
  route_table_id = aws_route_table.public_route_table[each.key].id
}

resource "aws_route_table_association" "private_association_internal" {
  for_each = var.vpcs

  subnet_id      = aws_subnet.internal_subnet[each.key].id
  route_table_id = aws_route_table.private_route_table[each.key].id
}

resource "aws_route_table_association" "private_association_db" {
  for_each = var.vpcs

  subnet_id      = aws_subnet.db_subnet[each.key].id
  route_table_id = aws_route_table.private_route_table[each.key].id
}