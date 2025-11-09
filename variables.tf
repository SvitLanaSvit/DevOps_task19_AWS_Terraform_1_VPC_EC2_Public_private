# Змінні для AWS VPC проекту

variable "aws_region" {
  description = "AWS регіон для створення ресурсів"
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Назва проекту для тегування ресурсів"
  type        = string
  default     = "terraform-vpc-exercise"
}

variable "vpc_cidr" {
  description = "CIDR блок для VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR блок для публічної підмережі"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR блок для приватної підмережі"  
  type        = string
  default     = "10.0.2.0/24"
}

variable "instance_type" {
  description = "Тип EC2 інстансу"
  type        = string
  default     = "t2.micro"
}

variable "public_key_content" {
  description = "Вміст публічного SSH ключа для доступу до EC2"
  type        = string
  sensitive   = true
}