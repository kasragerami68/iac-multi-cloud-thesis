# تنظیمات سرور - Server Configuration
# این فایل سرور EC2 می‌سازد و Docker را نصب می‌کند
# This file creates EC2 server and installs Docker

# ====================================================================
# Data Source: دریافت آخرین AMI اوبونتو
# Data Source: Get latest Ubuntu AMI
# ====================================================================

# پیدا کردن آخرین تصویر اوبونتو 22.04 - Find latest Ubuntu 22.04 image
data "aws_ami" "ubuntu" {
  most_recent = true  # جدیدترین - Most recent
  
  # فیلتر کردن - Filtering
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  
  # صاحب تصویر: Canonical (سازنده اوبونتو) - Owner: Canonical (Ubuntu creator)
  owners = ["099720109477"]
}

# ====================================================================
# Key Pair: کلید SSH برای دسترسی به سرور
# Key Pair: SSH key for server access
# ====================================================================

# ساخت کلید SSH - Create SSH key
#resource "aws_key_pair" "main" {
  #key_name   = "${var.project_name}-${var.environment}-key"
  
  # کلید عمومی - Public key
  # این رو بعداً باید تولید کنیم - We need to generate this later
  
  #public_key = file("~/.ssh/id_rsa.pub")  # - Or custom path
  
  #tags = {
    #Name = "${var.project_name}-${var.environment}-key"
  #}
#}

# ====================================================================
# EC2 Instance: سرور وب
# EC2 Instance: Web Server
# ====================================================================

# ساخت سرور EC2 - Create EC2 server
resource "aws_instance" "web" {
  # تصویر سیستم‌عامل - Operating system image
  ami = data.aws_ami.ubuntu.id
  
  # نوع سرور - Instance type
  instance_type = var.instance_type  # t2.micro (رایگان - Free Tier)
  
  # کلید SSH - SSH key
  #key_name = aws_key_pair.main.key_name
  
  # ====================================================================
  # تنظیمات شبکه - Network Settings
  # ====================================================================
  
  # Subnet - زیرشبکه
  subnet_id = aws_subnet.public_1.id
  
  # Security Groups - گروه‌های امنیتی
  vpc_security_group_ids = [aws_security_group.web_server.id]
  
  # IP عمومی - Public IP
  associate_public_ip_address = true  # برای دسترسی از اینترنت - For internet access
  
  # ====================================================================
  # تنظیمات دیسک - Disk Settings
  # ====================================================================
  
  # دیسک اصلی - Root disk
  root_block_device {
    volume_size = 30              # 30 گیگابایت - 30 GB
    volume_type = "gp3"           # SSD سریع - Fast SSD
    encrypted   = true            # رمزنگاری شده - Encrypted
    
    # حذف دیسک هنگام destroy - Delete disk on destroy
    delete_on_termination = true
    
    tags = {
      Name = "${var.project_name}-${var.environment}-root-volume"
    }
  }
  
  # ====================================================================
  # User Data: اسکریپت اولیه سرور
  # User Data: Server initialization script
  # ====================================================================
  
  # این اسکریپت وقتی سرور برای اولین بار روشن میشه اجرا میشه
  # This script runs when server boots for the first time
  user_data = templatefile("${path.module}/user-data.sh", {
    # ارسال متغیرها به اسکریپت - Pass variables to script
    db_host     = aws_db_instance.main.address
    db_port     = aws_db_instance.main.port
    db_name     = var.db_name
    db_username = var.db_username
    db_password = var.db_password
    project_name = var.project_name
  })
  
  # ====================================================================
  # وابستگی‌ها - Dependencies
  # ====================================================================
  
  # صبر کن تا دیتابیس آماده بشه - Wait until database is ready
  depends_on = [
    aws_db_instance.main,
    aws_internet_gateway.main
  ]
  
  # ====================================================================
  # تنظیمات پیشرفته - Advanced Settings
  # ====================================================================
  
  # نوع اجاره - Tenancy type
  tenancy = "default"  # Shared hardware (ارزان‌تر - Cheaper)
  
  # غیرفعال کردن protection - Disable termination protection
  disable_api_termination = false  # برای محیط dev - For dev environment
  
  # نظارت دقیق - Detailed monitoring
  monitoring = true  # نظارت CloudWatch - CloudWatch monitoring
  
  # ====================================================================
  # تگ‌ها - Tags
  # ====================================================================
  
  tags = {
    Name        = "${var.project_name}-${var.environment}-web-server"
    Environment = var.environment
    Purpose     = "Web Application Server"
    Role        = "Docker Host"
  }
}

# ====================================================================
# Elastic IP: آدرس IP ثابت
# Elastic IP: Static IP address
# ====================================================================

# ساخت IP ثابت - Create static IP
resource "aws_eip" "web" {
  # اتصال به سرور - Associate with instance
  instance = aws_instance.web.id
  
  # نوع - Type
  domain = "vpc"
  
  # وابستگی - Dependency
  depends_on = [aws_internet_gateway.main]
  
  tags = {
    Name = "${var.project_name}-${var.environment}-web-eip"
  }
}