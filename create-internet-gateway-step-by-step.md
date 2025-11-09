# 🌐 Створення Internet Gateway - Детальні інструкції

## 📋 Огляд кроку

**Мета**: Підключити публічну підмережу до інтернету через Internet Gateway  
**Статус**: ✅ Виконано успішно

---

## 🎯 Що досягли

### Створені ресурси:
1. **Internet Gateway**: `igw-09b662e0c74072dbf`
2. **Public Route Table**: `rtb-06137a896494091e1`  
3. **Route Table Association**: `rtbassoc-05c3e3e46ccb8b224`

### Архітектурна схема:
```
┌─────────────────────────────────────────────────────────┐
│                    Internet                             │
└─────────────────────┬───────────────────────────────────┘
                      │
                ┌─────▼─────┐
                │ Internet  │
                │ Gateway   │ igw-09b662e0c74072dbf
                └─────┬─────┘
                      │
┌─────────────────────▼───────────────────────────────────┐
│              VPC (10.0.0.0/16)                          │
│              vpc-0d0c0723032da8852                      │
│                                                         │
│  ┌─────────────────────────────────────────────────┐    │
│  │         Public Subnet (10.0.1.0/24)             │    │
│  │         subnet-0a01aeb1c1c5df18b                │    │
│  │         AZ: eu-central-1a                       │    │
│  │                                                 │    │
│  │  Route Table: rtb-06137a896494091e1             │    │
│  │  Route: 0.0.0.0/0 → igw-09b662e0c74072dbf       │    │
│  └─────────────────────────────────────────────────┘    │
│                                                         │
│  ┌─────────────────────────────────────────────────┐    │
│  │        Private Subnet (10.0.2.0/24)             │    │
│  │        subnet-058f889377a78fa60                 │    │
│  │        AZ: eu-central-1b                        │    │
│  │        (No internet access yet)                 │    │
│  └─────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────┘
```

---

## 💻 Код конфігурації

### 1. Internet Gateway (в main.tf):
```hcl
# Internet Gateway для публічного доступу
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}
```

### 2. Route Table для публічної підмережі:
```hcl
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
```

### 3. Association Route Table з підмережею:
```hcl
# Асоціація Route Table з публічною підмережею
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
```

### 4. Outputs (в outputs.tf):
```hcl
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
```

---

## 🔧 Команди виконання

### 1. Планування змін:
```bash
export AWS_PROFILE=sk-terraform-user
terraform plan
```
### 2. Застосування змін:
```bash
terraform apply -auto-approve
```

### 3. Перевірка outputs:
```bash
terraform output
```

**Результат**:
```
internet_gateway_id = "igw-09b662e0c74072dbf"
public_route_table_id = "rtb-06137a896494091e1"
vpc_id = "vpc-0d0c0723032da8852"
public_subnet_id = "subnet-0a01aeb1c1c5df18b"
```
**Скриншот**: [Screens/8.2_tf_output.png]
---

## 🔍 Перевірка в AWS Console

### 1. Перевірка Internet Gateway:
- **Перехід**: VPC → Internet Gateways
- **ID**: `igw-09b662e0c74072dbf`
- **Статус**: Attached to `vpc-0d0c0723032da8852`

**Скриншот**: [Screens/8.1_aws_igw.png]

### 2. Перевірка Route Table:
- **Перехід**: VPC → Route Tables
- **ID**: `rtb-06137a896494091e1`
- **Routes**: 
  - `10.0.0.0/16` → local
  - `0.0.0.0/0` → `igw-09b662e0c74072dbf`

**Скриншот**: [Screens/8.3_aws_route_table_public.png]

### 3. Перевірка Subnet Associations:
- **Route Table**: `rtb-06137a896494091e1`
- **Associated Subnets**: `subnet-0a01aeb1c1c5df18b` (Public)

**Скриншот**: [Screens/8.4_aws_subnet_associations_route_table_public.png]

---

## ✅ Результат

### Що досягнуто:
1. ✅ **Internet Gateway створено та підключено** до VPC
2. ✅ **Route Table налаштовано** для публічної підмережі  
3. ✅ **Маршрутизація налаштована** (0.0.0.0/0 → IGW)
4. ✅ **Публічна підмережа отримала доступ до інтернету**

### Наступний крок:
🔀 **Крок 5**: Створення NAT Gateway для приватної підмережі

---

## 🔗 Корисні посилання

- [AWS Internet Gateway Documentation](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html)
- [Terraform aws_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway)
- [AWS Route Tables Guide](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html)