# ===========================================
# Lab Environment Variables (Current)
# ===========================================  
# Використання: terraform apply -var-file="environments/lab.tfvars"

# AWS Configuration
aws_region = "eu-central-1"

# Project Configuration
project_name = "terraform-vpc-exercise"  # Поточне значення
environment  = "lab"

# Network Configuration  
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidr   = "10.0.1.0/24"
private_subnet_cidr  = "10.0.2.0/24"

# EC2 Configuration
instance_type = "t2.micro"