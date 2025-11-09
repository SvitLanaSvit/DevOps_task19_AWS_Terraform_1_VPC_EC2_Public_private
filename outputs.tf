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

# Subnet Outputs
output "public_subnet_id" {
  description = "ID публічної підмережі"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID приватної підмережі"
  value       = aws_subnet.private.id
}

output "public_subnet_cidr" {
  description = "CIDR блок публічної підмережі"
  value       = aws_subnet.public.cidr_block
}

output "private_subnet_cidr" {
  description = "CIDR блок приватної підмережі"
  value       = aws_subnet.private.cidr_block
}

# Internet Gateway Outputs
output "internet_gateway_id" {
  description = "ID Internet Gateway"
  value       = aws_internet_gateway.main.id
}

# Route Table Outputs
output "public_route_table_id" {
  description = "ID Route Table для публічної підмережі"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "ID Route Table для приватної підмережі"
  value       = aws_route_table.private.id
}

# NAT Gateway Outputs
output "nat_gateway_id" {
  description = "ID NAT Gateway"
  value       = aws_nat_gateway.main.id
}

output "nat_eip_public_ip" {
  description = "Публічний IP адрес NAT Gateway"
  value       = aws_eip.nat.public_ip
}

output "nat_eip_id" {
  description = "ID Elastic IP для NAT Gateway"
  value       = aws_eip.nat.id
}

# TODO: Будуть додані outputs для:
# - Security Groups  
# - EC2 instance IPs
# - SSH команди для підключення