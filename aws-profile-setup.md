# Налаштування AWS Profile для Terraform

## ⚠️ ВАЖЛИВО: Чому потрібен export AWS_PROFILE

### Проблема з профілями AWS

При роботі з Terraform та AWS CLI виникає важлива особливість:

**Terraform Backend S3** ініціалізується **ДО** завантаження provider конфігурації, тому параметр `profile = "sk-terraform-user"` в backend може не працювати і Terraform використовуватиме **default профіль**.

### Перевірка поточного користувача

Щоб перевірити, якого користувача використовує AWS CLI:

```bash
aws sts get-caller-identity
```

**Приклад виводу з проблемою:**
```json
{
    "UserId": "AIDAZDSAHYO4A46RJX7PJ",
    "Account": "626126209976",
    "Arn": "arn:aws:iam::626126209976:user/svitlana.kizilpinar@gmail.com"
}
```
☝️ **Це НЕ той користувач!** У нього немає доступу до S3.

**Правильний вивід:**
```json
{
    "UserId": "AIDAZDSAHYO4OSLV6IJE4",
    "Account": "626126209976",
    "Arn": "arn:aws:iam::626126209976:user/sk-terraform-user"
}
```
✅ **Це правильний користувач** з доступом до S3.

### 🔧 Рішення: Встановлення AWS_PROFILE

**Для bash/Linux/WSL:**
```bash
export AWS_PROFILE=sk-terraform-user
```

### Перевірка після налаштування

```bash
# Перевірте змінну середовища
echo $AWS_PROFILE

# Перевірте користувача AWS
aws sts get-caller-identity

# Перевірте доступ до S3
aws s3 ls s3://terraform-state-svitlana-vpc
```

### 📝 Алгоритм пошуку credentials в AWS CLI

AWS CLI шукає credentials в такому порядку:

1. **Змінні середовища**: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`
2. **AWS_PROFILE змінна**: `export AWS_PROFILE=sk-terraform-user` ← **Наше рішення**
3. **Параметр profile** в конфігурації Terraform
4. **Default профіль** в `~/.aws/credentials` ← **Тут була проблема**
5. **IAM ролі** (для EC2 інстансів)

### ❌ Що НЕ працює

```hcl
# Це може не працювати для backend!
backend "s3" {
  profile = "sk-terraform-user"  # ← Backend ігнорує це
  bucket  = "terraform-state-svitlana-vpc"
  # ...
}
```

### ✅ Що працює

```bash
# Встановити перед роботою з Terraform
export AWS_PROFILE=sk-terraform-user

# Тепер всі команди працюють
terraform init
terraform plan  
terraform apply
```

### 🎯 Альтернативні рішення

**Варіант 1: Змінити default профіль**
Перейменувати в `~/.aws/credentials`:
```ini
[default]  # ← замість [sk-terraform-user]
aws_access_key_id = AKIAxxx
aws_secret_access_key = xxx

[old-user]  # ← перенести старий default сюди
aws_access_key_id = AKIAxxx  
aws_secret_access_key = xxx
```

**Варіант 2: Прямі змінні середовища**
```bash
export AWS_ACCESS_KEY_ID="AKIAxxx"
export AWS_SECRET_ACCESS_KEY="xxx"
export AWS_DEFAULT_REGION="eu-central-1"
```

---

## 📋 Чеклист перед роботою з Terraform

- [ ] `export AWS_PROFILE=sk-terraform-user`
- [ ] `aws sts get-caller-identity` показує правильного користувача
- [ ] `aws s3 ls s3://terraform-state-svitlana-vpc` працює
- [ ] `terraform init` успішний
- [ ] `terraform plan` працює без помилок

**📸 СКРІНШОТ**: Приклад правильного виводу після встановлення AWS_PROFILE

![Правильний вивід aws sts get-caller-identity](screens/5.2_output_right_with_user_after_export.png)