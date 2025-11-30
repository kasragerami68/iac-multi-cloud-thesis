# تنظیمات دیتابیس - Database Configuration
# این فایل دیتابیس MySQL در AWS RDS می‌سازد
# This file creates MySQL database in AWS RDS

# ====================================================================
# RDS MySQL Database Instance - دیتابیس MySQL
# ====================================================================

# ساخت دیتابیس RDS - Create RDS Database
resource "aws_db_instance" "main" {
  # شناسه دیتابیس - Database identifier
  identifier = "${var.project_name}-${var.environment}-db"
  
  # ====================================================================
  # تنظیمات موتور دیتابیس - Database Engine Settings
  # ====================================================================
  
  # نوع دیتابیس - Database type
  engine         = "mysql"
  
  # نسخه MySQL - MySQL version
  engine_version = "8.0"
  
  # ====================================================================
  # تنظیمات منابع - Resource Settings
  # ====================================================================
  
  # نوع سرور دیتابیس - Database server type
  instance_class = var.db_instance_class  # db.t3.micro (رایگان - Free Tier)
  
  # فضای ذخیره‌سازی به گیگابایت - Storage in GB
  allocated_storage = var.db_allocated_storage  # 20 GB
  
  # نوع ذخیره‌سازی - Storage type
  storage_type = "gp3"  # General Purpose SSD (سریع‌تر و ارزان‌تر - Faster and cheaper)
  
  # ====================================================================
  # اطلاعات ورود - Login Credentials
  # ====================================================================
  
  # نام دیتابیس - Database name
  db_name = var.db_name  # community_db
  
  # نام کاربری مدیر - Master username
  username = var.db_username  # kasra
  
  # رمز عبور مدیر - Master password
  password = var.db_password  # test1234
  
  # ====================================================================
  # تنظیمات شبکه - Network Settings
  # ====================================================================
  
  # گروه Subnet برای دیتابیس - Subnet group for database
  db_subnet_group_name = aws_db_subnet_group.main.name
  
  # گروه‌های امنیتی - Security groups
  vpc_security_group_ids = [aws_security_group.database.id]
  
  # دسترسی عمومی - Public access
  publicly_accessible = false  # فقط از داخل VPC قابل دسترسی - Only accessible from VPC
  
  # ====================================================================
  # تنظیمات پشتیبان‌گیری - Backup Settings
  # ====================================================================
  
  # پشتیبان‌گیری خودکار - Automated backups
  backup_retention_period = 0  # 7 روز - 7 days
  
  # زمان پشتیبان‌گیری (UTC) - Backup window (UTC)
  backup_window = "03:00-04:00"  # 3 صبح تا 4 صبح - 3 AM to 4 AM
  
  # ====================================================================
  # تنظیمات نگهداری - Maintenance Settings
  # ====================================================================
  
  # زمان نگهداری - Maintenance window
  maintenance_window = "Mon:04:00-Mon:05:00"  # دوشنبه 4 تا 5 صبح - Monday 4-5 AM
  
  # اعمال خودکار آپدیت‌های جزئی - Auto apply minor updates
  auto_minor_version_upgrade = true
  
  # ====================================================================
  # تنظیمات حذف - Deletion Settings
  # ====================================================================
  
  # حذف پشتیبان‌ها هنگام destroy - Delete backups on destroy
  skip_final_snapshot = true  # برای محیط dev - For dev environment
  
  # جلوگیری از حذف تصادفی - Protection against accidental deletion
  deletion_protection = false  # در محیط dev false - False in dev
  
  # ====================================================================
  # تنظیمات عملکرد - Performance Settings
  # ====================================================================
  
  # فعال کردن Performance Insights - Enable Performance Insights
  enabled_cloudwatch_logs_exports = ["error", "general", "slowquery"]
  
  # ====================================================================
  # تنظیمات پارامترها - Parameter Settings
  # ====================================================================
  
  # گروه پارامترها - Parameter group
  parameter_group_name = aws_db_parameter_group.main.name
  
  # ====================================================================
  # تگ‌ها - Tags
  # ====================================================================
  
  tags = {
    Name        = "${var.project_name}-${var.environment}-db"
    Environment = var.environment
    Purpose     = "Application Database"
  }
}

# ====================================================================
# DB Parameter Group - گروه پارامترهای دیتابیس
# ====================================================================

# تنظیمات سفارشی MySQL - Custom MySQL settings
resource "aws_db_parameter_group" "main" {
  # نام گروه - Group name
  name   = "${var.project_name}-${var.environment}-mysql-params"
  
  # خانواده دیتابیس - Database family
  family = "mysql8.0"
  
  # توضیحات - Description
  description = "MySQL parameter group"
  
  # ====================================================================
  # پارامترهای سفارشی - Custom Parameters
  # ====================================================================
  
  # حداکثر اتصالات همزمان - Maximum concurrent connections
  parameter {
    name  = "max_connections"
    value = "100"  # برای t3.micro مناسب - Suitable for t3.micro
  }
  
  # Character Set پیش‌فرض - Default character set
  parameter {
    name  = "character_set_server"
    value = "utf8mb4"  # پشتیبانی از Emoji و زبان‌های مختلف - Support for Emoji and various languages
  }
  
  # Collation پیش‌فرض - Default collation
  parameter {
    name  = "collation_server"
    value = "utf8mb4_unicode_ci"
  }
  
  # زمان‌بندی رویداد - Event scheduling
  parameter {
    name  = "event_scheduler"
    value = "ON"
  }
  
  # تنظیمات Slow Query Log - Slow query log settings
  parameter {
    name  = "slow_query_log"
    value = "1"  # فعال - Enabled
  }
  
  # زمان Slow Query (ثانیه) - Slow query time (seconds)
  parameter {
    name  = "long_query_time"
    value = "2"  # Query های بیشتر از 2 ثانیه لاگ میشن - Queries longer than 2s are logged
  }
  
  tags = {
    Name = "${var.project_name}-${var.environment}-mysql-params"
  }
}

# ====================================================================
# Random Password (اختیاری - برای تولید رمز تصادفی)
# Optional - For generating random password
# ====================================================================

# اگه می‌خواید رمز عبور تصادفی تولید بشه، این کامنت رو بردارید
# Uncomment this if you want to generate random password

# resource "random_password" "db_password" {
#   length  = 16
#   special = true
# }