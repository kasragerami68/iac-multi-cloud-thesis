# متغیرهای پروژه - Project Variables
# این فایل شامل تمام متغیرهای قابل تنظیم پروژه است
# This file contains all configurable project variables

# نام پروژه - Project name
variable "project_name" {
  description = "نام پروژه که برای نام‌گذاری منابع استفاده می‌شود - Project name used for naming resources"
  type        = string
  default     = "iac-web-app"
}

# محیط (توسعه، تولید) - Environment (development, production)
variable "environment" {
  description = "محیط اجرا (dev, staging, prod) - Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

# منطقه AWS - AWS Region
variable "aws_region" {
  description = "منطقه جغرافیایی AWS - AWS geographic region"
  type        = string
  default     = "us-east-1"
}

# نوع Instance - Instance Type
variable "instance_type" {
  description = "نوع سرور EC2 - EC2 instance type"
  type        = string
  default     = "t3.micro"  # رایگان در Free Tier - Free in Free Tier
}

# نام کاربری دیتابیس - Database Username
variable "db_username" {
  description = "نام کاربری دیتابیس MySQL - MySQL database username"
  type        = string
  default     = "kasra"
  sensitive   = true  # این متغیر حساس است - This variable is sensitive
}

# رمز عبور دیتابیس - Database Password
variable "db_password" {
  description = "رمز عبور دیتابیس MySQL - MySQL database password"
  type        = string
  default     = "test1234"
  sensitive   = true  # این رمز در لاگ‌ها نمایش داده نمی‌شود - Password won't show in logs
}

# نام دیتابیس - Database Name
variable "db_name" {
  description = "نام دیتابیس - Database name"
  type        = string
  default     = "community_db"
}

# نوع Instance دیتابیس - Database Instance Type
variable "db_instance_class" {
  description = "نوع سرور دیتابیس - Database server type"
  type        = string
  default     = "db.t3.micro"  # رایگان در Free Tier - Free in Free Tier
}

# فضای ذخیره‌سازی دیتابیس (گیگابایت) - Database Storage (GB)
variable "db_allocated_storage" {
  description = "فضای ذخیره‌سازی دیتابیس به گیگابایت - Database storage in GB"
  type        = number
  default     = 20  # حداقل مجاز - Minimum allowed
}

# تگ‌های مشترک - Common Tags
variable "common_tags" {
  description = "تگ‌های مشترک برای تمام منابع - Common tags for all resources"
  type        = map(string)
  default = {
    Project     = "IaC-Multi-Cloud-Thesis"
    ManagedBy   = "Terraform"
    Owner       = "Kasra Gerami"
    University  = "University of Northampton"
  }
}