# Виводи Terraform після створення інфраструктури

output "aws_region" {
  description = "AWS регіон використаний для проекту"
  value       = var.aws_region
}

output "project_name" {
  description = "Назва проекту"
  value       = var.project_name
}

output "availability_zones" {
  description = "Доступні зони доступності в регіоні"
  value       = data.aws_availability_zones.available.names
}

# Backend ресурси (тимчасово закоментовано - bucket створений окремо)
# output "terraform_state_bucket" {
#   description = "S3 bucket для збереження Terraform state"
#   value       = aws_s3_bucket.terraform_state.bucket
# }

# VPC Outputs
output "vpc_id" {
  description = "ID створеного VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR блок VPC"
  value       = aws_vpc.main.cidr_block
}

# TODO: Будуть додані outputs для:
# - Subnet IDs  
# - EC2 instance IPs
# - SSH команди для підключення