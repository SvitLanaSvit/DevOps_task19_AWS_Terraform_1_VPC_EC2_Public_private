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

# Security Groups Outputs
output "public_security_group_id" {
  description = "ID Security Group для публічного EC2"
  value       = aws_security_group.public_ec2.id
}

output "private_security_group_id" {
  description = "ID Security Group для приватного EC2"
  value       = aws_security_group.private_ec2.id
}

# EC2 Instance Outputs
output "public_ec2_id" {
  description = "ID публічного EC2 instance"
  value       = aws_instance.public.id
}

output "public_ec2_public_ip" {
  description = "Публічний IP адрес публічного EC2"
  value       = aws_instance.public.public_ip
}

output "public_ec2_private_ip" {
  description = "Приватний IP адрес публічного EC2"
  value       = aws_instance.public.private_ip
}

output "private_ec2_id" {
  description = "ID приватного EC2 instance"
  value       = aws_instance.private.id
}

output "private_ec2_private_ip" {
  description = "Приватний IP адрес приватного EC2"
  value       = aws_instance.private.private_ip
}

# Key Pair Output
output "key_pair_name" {
  description = "Назва створеної Key Pair"
  value       = aws_key_pair.main.key_name
}

# SSH Commands
output "ssh_command_public" {
  description = "Команда для SSH підключення до публічного EC2"
  value       = "ssh -i ~/.ssh/id_rsa ubuntu@${aws_instance.public.public_ip}"
}

output "ssh_command_private" {
  description = "Команда для SSH підключення до приватного EC2 через Jump Host"
  value       = "ssh -i ~/.ssh/id_rsa -o ProxyCommand=\"ssh -i ~/.ssh/id_rsa -W %h:%p ubuntu@${aws_instance.public.public_ip}\" ubuntu@${aws_instance.private.private_ip}"
}

# AMI Information
output "ubuntu_ami_id" {
  description = "ID використаного Ubuntu AMI"
  value       = data.aws_ami.ubuntu.id
}

output "ubuntu_ami_name" {
  description = "Назва використаного Ubuntu AMI"
  value       = data.aws_ami.ubuntu.name
}