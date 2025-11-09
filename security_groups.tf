# ========================================
# SECURITY GROUPS
# ========================================
# Цей файл містить ресурси для Security Groups

# Security Group для публічного EC2 (Jump Host / Bastion)
resource "aws_security_group" "public_ec2" {
  name        = "${var.project_name}-public-sg"
  description = "Security Group for public EC2 instance (Jump Host)"
  vpc_id      = aws_vpc.main.id

  # SSH доступ з інтернету
  ingress {
    description = "SSH from Internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Весь вихідний трафік
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-public-sg"
    Type = "Public"
  }
}

# Security Group для приватного EC2
resource "aws_security_group" "private_ec2" {
  name        = "${var.project_name}-private-sg"
  description = "Security Group for private EC2 instance"
  vpc_id      = aws_vpc.main.id

  # SSH тільки з публічної підмережі (Jump Host)
  ingress {
    description = "SSH from Public Subnet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.public_subnet_cidr]
  }

  # Весь вихідний трафік (для оновлень через NAT)
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-private-sg"
    Type = "Private"
  }
}