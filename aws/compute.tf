# Server Configuration - EC2 Instance and Docker

# ====================================================================
# Data Source: Latest Ubuntu AMI
# ====================================================================

data "aws_ami" "ubuntu" {
  most_recent = true
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  
  owners = ["099720109477"]  # Canonical
}

# ====================================================================
# EC2 Instance - Web Server
# ====================================================================

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  
  # Network Settings
  subnet_id                   = aws_subnet.public_1.id
  vpc_security_group_ids      = [aws_security_group.web_server.id]
  associate_public_ip_address = true
  
  # Root Disk Configuration
  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
    
    tags = {
      Name = "${var.project_name}-${var.environment}-root-volume"
    }
  }
  
  # Initialization Script
  user_data = templatefile("${path.module}/user-data.sh", {
    db_host      = aws_db_instance.main.address
    db_port      = aws_db_instance.main.port
    db_name      = var.db_name
    db_username  = var.db_username
    db_password  = var.db_password
    project_name = var.project_name
  })
  
  # Dependencies
  depends_on = [
    aws_db_instance.main,
    aws_internet_gateway.main
  ]
  
  # Advanced Settings
  tenancy                 = "default"
  disable_api_termination = false
  monitoring              = true
  
  tags = {
    Name        = "${var.project_name}-${var.environment}-web-server"
    Environment = var.environment
    Purpose     = "Web Application Server"
    Role        = "Docker Host"
  }
}

# ====================================================================
# Elastic IP - Static Public IP
# ====================================================================

resource "aws_eip" "web" {
  instance   = aws_instance.web.id
  domain     = "vpc"
  depends_on = [aws_internet_gateway.main]
  
  tags = {
    Name = "${var.project_name}-${var.environment}-web-eip"
  }
}