# ========================================
# AWS Terraform VPC Exercise - Main Configuration  
# ========================================
# Основна конфігурація для створення VPC з публічними та приватними підмережами
#
# Структура проекту:
# - main.tf              - Terraform блок, provider, data sources
# - vpc.tf               - VPC та підмережі
# - internet_gateway.tf  - Internet Gateway та публічна маршрутизація
# - nat_gateway.tf       - NAT Gateway та приватна маршрутизація
# - security_groups.tf   - Security Groups для EC2
# - ec2.tf               - EC2 instances та Key Pair
# - variables.tf         - змінні проекту
# - outputs.tf           - outputs проекту
# ========================================

# Terraform конфігурація
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

# ========================================
# AWS PROVIDER
# ========================================

# Конфігурація AWS провайдера
provider "aws" {
  region = var.aws_region
}

# ========================================
# DATA SOURCES
# ========================================

# Отримання доступних зон доступності
data "aws_availability_zones" "available" {
  state = "available"
}

# Отримання актуального Ubuntu 22.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# EOF - End of main.tf
# Всі інші ресурси винесені в окремі файли для кращої читабельності