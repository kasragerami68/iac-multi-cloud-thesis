# تنظیمات شبکه و امنیت - Network and Security Configuration
# این فایل شامل VPC، Subnets، و Security Groups است
# This file contains VPC, Subnets, and Security Groups

# ====================================================================
# VPC - شبکه خصوصی مجازی - Virtual Private Cloud
# ====================================================================

# ساخت VPC - Create VPC
resource "aws_vpc" "main" {
  # محدوده آدرس‌های IP - IP address range
  cidr_block = "10.0.0.0/16"
  
  # فعال کردن DNS hostname - Enable DNS hostname
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  # تگ‌ها - Tags
  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}

# ====================================================================
# Internet Gateway - دروازه اینترنت
# ====================================================================

# ساخت Internet Gateway برای اتصال به اینترنت
# Create Internet Gateway for internet connection
resource "aws_internet_gateway" "main" {
  # متصل کردن به VPC - Attach to VPC
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "${var.project_name}-${var.environment}-igw"
  }
}

# ====================================================================
# Subnets - زیرشبکه‌ها
# ====================================================================

# Subnet عمومی 1 - Public Subnet 1
resource "aws_subnet" "public_1" {
  vpc_id = aws_vpc.main.id
  
  # محدوده IP این subnet - IP range for this subnet
  cidr_block = "10.0.1.0/24"
  
  # Availability Zone اول - First availability zone
  availability_zone = "${var.aws_region}a"
  
  # IP عمومی خودکار - Auto-assign public IP
  map_public_ip_on_launch = true
  
  tags = {
    Name = "${var.project_name}-${var.environment}-public-subnet-1"
    Type = "Public"
  }
}

# Subnet عمومی 2 - Public Subnet 2
# RDS به حداقل 2 subnet در AZ های مختلف نیاز دارد
# RDS requires at least 2 subnets in different AZs
resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "${var.project_name}-${var.environment}-public-subnet-2"
    Type = "Public"
  }
}

# ====================================================================
# Route Table - جدول مسیریابی
# ====================================================================

# جدول مسیریابی برای Subnets عمومی
# Route table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  
  # مسیر به اینترنت - Route to internet
  route {
    cidr_block = "0.0.0.0/0"  # تمام آدرس‌ها - All addresses
    gateway_id = aws_internet_gateway.main.id
  }
  
  tags = {
    Name = "${var.project_name}-${var.environment}-public-rt"
  }
}

# اتصال جدول مسیریابی به Subnet 1
# Associate route table with Subnet 1
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

# اتصال جدول مسیریابی به Subnet 2
# Associate route table with Subnet 2
resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# ====================================================================
# Security Groups - گروه‌های امنیتی (فایروال)
# ====================================================================

# Security Group برای سرور وب - Security Group for web server
resource "aws_security_group" "web_server" {
  name        = "${var.project_name}-${var.environment}-web-sg"
  description = "Security group for web server"
  vpc_id      = aws_vpc.main.id
  
  # قوانین ورودی - Inbound rules
  
  # اجازه HTTP از همه جا - Allow HTTP from anywhere
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # اجازه HTTPS از همه جا - Allow HTTPS from anywhere
  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # اجازه SSH برای مدیریت - Allow SSH for management
  ingress {
    description = "SSH for management"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # توجه: در production باید محدود شود - Note: Should be restricted in production
  }
  
  # اجازه پورت App (9090) - Allow App port
  ingress {
    description = "Application port"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # قوانین خروجی - Outbound rules
  
  # اجازه تمام ترافیک خروجی - Allow all outbound traffic
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # تمام پروتکل‌ها - All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "${var.project_name}-${var.environment}-web-sg"
  }
}

# Security Group برای دیتابیس - Security Group for database
resource "aws_security_group" "database" {
  name        = "${var.project_name}-${var.environment}-db-sg"
  description = "Security group for database"
  vpc_id      = aws_vpc.main.id
  
  # قوانین ورودی - Inbound rules
  
  # فقط از سرور وب اجازه اتصال به MySQL - Only allow MySQL from web server
  ingress {
    description     = "MySQL from web server"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_server.id]  # فقط از web server - Only from web server
  }
  
  # قوانین خروجی - Outbound rules
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "${var.project_name}-${var.environment}-db-sg"
  }
}

# ====================================================================
# DB Subnet Group - گروه Subnet برای دیتابیس
# ====================================================================

# RDS نیاز داره که Subnets رو در یک گروه قرار بدیم
# RDS requires subnets to be in a group
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = [aws_subnet.public_1.id, aws_subnet.public_2.id]
  
  description = "Subnet group for RDS database"
  
  tags = {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
  }
}