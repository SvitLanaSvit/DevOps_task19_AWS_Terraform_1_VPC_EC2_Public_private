# ========================================
# NAT GATEWAY & PRIVATE ROUTING
# ========================================
# Цей файл містить ресурси для NAT Gateway та приватної маршрутизації

# Elastic IP для NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
  
  tags = {
    Name = "${var.project_name}-nat-eip"
  }

  # Залежить від Internet Gateway
  depends_on = [aws_internet_gateway.main]
}

# NAT Gateway у публічній підмережі
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "${var.project_name}-nat-gw"
  }

  # Залежить від Internet Gateway
  depends_on = [aws_internet_gateway.main]
}

# Route Table для приватної підмережі
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-private-rt"
  }
}

# Асоціація Route Table з приватною підмережею
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}