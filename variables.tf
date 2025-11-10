# Змінні для AWS VPC проекту

variable "aws_region" {
  description = "AWS регіон для створення ресурсів"
  type        = string
}

variable "project_name" {
  description = "Назва проекту для тегування ресурсів"
  type        = string
}

variable "environment" {
  description = "Environment name lab"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR блок для VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR блок для публічної підмережі"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR блок для приватної підмережі"  
  type        = string
}

variable "instance_type" {
  description = "Тип EC2 інстансу"
  type        = string
}

variable "public_key_content" {
  description = "Вміст публічного SSH ключа для доступу до EC2"
  type        = string
  sensitive   = true
}