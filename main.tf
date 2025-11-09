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