# AWS Terraform VPC Exercise
# Основна конфігурація для створення VPC з публічними та приватними підмережами

terraform {
  required_version = "~>1.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  
  # S3 Backend для збереження tfstate файлу
  backend "s3" {
    bucket  = "terraform-state-svitlana-vpc"
    key     = "terraform/terraform.tfstate"
    region  = "eu-central-1"
    encrypt = true
  }
}

# Конфігурація AWS провайдера
provider "aws" {
  region = var.aws_region
}

# Отримання доступних зон доступності
data "aws_availability_zones" "available" {
  state = "available"
}

# ========================================
# VPC RESOURCES
# ========================================

# Основний VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Публічна підмережа
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet"
    Type = "Public"
  }
}

# Приватна підмережа
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.project_name}-private-subnet"
    Type = "Private"
  }
}

# ========================================
# INTERNET GATEWAY & ROUTING
# ========================================

# Internet Gateway для публічного доступу
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Route Table для публічної підмережі
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# Асоціація Route Table з публічною підмережею
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# ========================================
# NAT GATEWAY & PRIVATE ROUTING
# ========================================

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

# ========================================
# SECURITY GROUPS
# ========================================

# Security Group для публічного EC2 (Jump Host / Bastion)
resource "aws_security_group" "public_ec2" {
  name        = "${var.project_name}-public-sg"
  description = "Security Group for public EC2 instance (Jump Host)"
  vpc_id      = aws_vpc.main.id

  # SSH доступ з вашої IP адреси
  ingress {
    description = "SSH from My IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # УВАГА: замініть на вашу IP для безпеки
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
    cidr_blocks = ["10.0.1.0/24"]
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