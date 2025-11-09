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