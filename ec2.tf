# ========================================
# EC2 INSTANCES
# ========================================
# Цей файл містить ресурси для EC2 instances та Key Pair

# Key Pair для EC2 instances
resource "aws_key_pair" "main" {
  key_name   = "${var.project_name}-key"
  public_key = var.public_key_content

  tags = {
    Name = "${var.project_name}-key-pair"
  }
}

# EC2 Instance у публічній підмережі (Jump Host / Bastion)
resource "aws_instance" "public" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.main.key_name
  vpc_security_group_ids = [aws_security_group.public_ec2.id]
  subnet_id              = aws_subnet.public.id

  # User data script для початкової конфігурації
  user_data_base64 = base64encode(file("${path.module}/templates/public-ec2-userdata.sh"))

  tags = {
    Name        = "${var.project_name}-public-ec2"
    Type        = "Public"
    Environment = var.environment
    Role        = "Jump-Host"
  }
}

# EC2 Instance у приватній підмережі
resource "aws_instance" "private" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.main.key_name
  vpc_security_group_ids = [aws_security_group.private_ec2.id]
  subnet_id              = aws_subnet.private.id

  # User data script для початкової конфігурації
  user_data_base64 = base64encode(file("${path.module}/templates/private-ec2-userdata.sh"))

  tags = {
    Name        = "${var.project_name}-private-ec2"
    Type        = "Private"
    Environment = var.environment
    Role        = "Backend-Server"
  }
}