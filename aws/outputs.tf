# خروجی‌ها - Outputs
# این فایل اطلاعات مهم را بعد از اجرای Terraform نمایش می‌دهد
# This file displays important information after Terraform execution

# ====================================================================
# اطلاعات سرور - Server Information
# ====================================================================

# آدرس IP عمومی سرور - Server public IP address
output "web_server_public_ip" {
  description = "آدرس IP عمومی سرور وب - Web server public IP address"
  value       = aws_eip.web.public_ip
}

# آدرس IP خصوصی سرور - Server private IP address
output "web_server_private_ip" {
  description = "آدرس IP خصوصی سرور وب - Web server private IP address"
  value       = aws_instance.web.private_ip
}

# شناسه سرور - Server instance ID
output "web_server_instance_id" {
  description = "شناسه EC2 Instance - EC2 Instance ID"
  value       = aws_instance.web.id
}

# نوع سرور - Server instance type
output "web_server_instance_type" {
  description = "نوع EC2 Instance - EC2 Instance type"
  value       = aws_instance.web.instance_type
}

# منطقه در دسترس بودن سرور - Server availability zone
output "web_server_availability_zone" {
  description = "منطقه در دسترس بودن سرور - Server availability zone"
  value       = aws_instance.web.availability_zone
}

# ====================================================================
# اطلاعات دیتابیس - Database Information
# ====================================================================

# آدرس دیتابیس - Database endpoint
output "database_endpoint" {
  description = "آدرس اتصال به دیتابیس - Database connection endpoint"
  value       = aws_db_instance.main.endpoint
}

# آدرس هاست دیتابیس - Database host address
output "database_host" {
  description = "آدرس هاست دیتابیس - Database host address"
  value       = aws_db_instance.main.address
}

# پورت دیتابیس - Database port
output "database_port" {
  description = "پورت دیتابیس - Database port"
  value       = aws_db_instance.main.port
}

# نام دیتابیس - Database name
output "database_name" {
  description = "نام دیتابیس - Database name"
  value       = aws_db_instance.main.db_name
}

# شناسه دیتابیس - Database identifier
output "database_identifier" {
  description = "شناسه RDS Instance - RDS Instance identifier"
  value       = aws_db_instance.main.identifier
}

# ====================================================================
# اطلاعات شبکه - Network Information
# ====================================================================

# شناسه VPC - VPC ID
output "vpc_id" {
  description = "شناسه VPC - VPC ID"
  value       = aws_vpc.main.id
}

# محدوده CIDR VPC - VPC CIDR block
output "vpc_cidr_block" {
  description = "محدوده CIDR VPC - VPC CIDR block"
  value       = aws_vpc.main.cidr_block
}

# شناسه Subnet عمومی 1 - Public subnet 1 ID
output "public_subnet_1_id" {
  description = "شناسه Subnet عمومی 1 - Public subnet 1 ID"
  value       = aws_subnet.public_1.id
}

# شناسه Subnet عمومی 2 - Public subnet 2 ID
output "public_subnet_2_id" {
  description = "شناسه Subnet عمومی 2 - Public subnet 2 ID"
  value       = aws_subnet.public_2.id
}

# ====================================================================
# URL های دسترسی - Access URLs
# ====================================================================

# URL اصلی برنامه - Main application URL
output "application_url" {
  description = "آدرس برنامه وب - Web application URL"
  value       = "http://${aws_eip.web.public_ip}:9090"
}

# دستور SSH برای اتصال به سرور - SSH command to connect to server
output "ssh_connection_command" {
  description = "دستور SSH برای اتصال به سرور - SSH command to connect to server"
  value       = "ssh -i ~/.ssh/id_rsa ubuntu@${aws_eip.web.public_ip}"
}

# ====================================================================
# اطلاعات امنیتی - Security Information
# ====================================================================

# شناسه Security Group سرور وب - Web server security group ID
output "web_security_group_id" {
  description = "شناسه Security Group سرور وب - Web server security group ID"
  value       = aws_security_group.web_server.id
}

# شناسه Security Group دیتابیس - Database security group ID
output "database_security_group_id" {
  description = "شناسه Security Group دیتابیس - Database security group ID"
  value       = aws_security_group.database.id
}

# ====================================================================
# دستورات مفید - Useful Commands
# ====================================================================

# دستورات مدیریتی - Management commands
output "management_commands" {
  description = "دستورات مفید برای مدیریت - Useful management commands"
  value = <<-EOT
  
  📋 دستورات مفید / Useful Commands:
  =====================================
  
  🌐 دسترسی به برنامه / Access Application:
     ${aws_eip.web.public_ip}:9090
  
  🔌 اتصال به سرور / Connect to Server:
     ssh ubuntu@${aws_eip.web.public_ip}
  
  📊 مشاهده وضعیت / View Status:
     ssh ubuntu@${aws_eip.web.public_ip} "docker ps"
  
  📝 مشاهده لاگ‌ها / View Logs:
     ssh ubuntu@${aws_eip.web.public_ip} "docker-compose logs -f"
  
  🔄 ری‌استارت برنامه / Restart Application:
     ssh ubuntu@${aws_eip.web.public_ip} "cd /opt/${var.project_name} && docker-compose restart"
  
  🗄️ اتصال به دیتابیس / Connect to Database:
     mysql -h ${aws_db_instance.main.address} -u ${var.db_username} -p ${var.db_name}
  
  =====================================
  EOT
}

# ====================================================================
# خلاصه منابع - Resources Summary
# ====================================================================

# خلاصه کامل منابع ساخته شده - Complete summary of created resources
output "deployment_summary" {
  description = "خلاصه کامل منابع ساخته شده - Complete summary of created resources"
  value = <<-EOT
  
  🎉 استقرار موفقیت‌آمیز بود! / Deployment Successful!
  =====================================================
  
  📌 اطلاعات پروژه / Project Information:
     نام پروژه / Project: ${var.project_name}
     محیط / Environment: ${var.environment}
     منطقه / Region: ${var.aws_region}
  
  🖥️ سرور وب / Web Server:
     IP عمومی / Public IP: ${aws_eip.web.public_ip}
     نوع سرور / Instance Type: ${aws_instance.web.instance_type}
     Availability Zone: ${aws_instance.web.availability_zone}
  
  🗄️ دیتابیس / Database:
     Host: ${aws_db_instance.main.address}
     Port: ${aws_db_instance.main.port}
     Database: ${aws_db_instance.main.db_name}
     Engine: MySQL ${aws_db_instance.main.engine_version}
  
  🌐 دسترسی / Access:
     برنامه / Application: http://${aws_eip.web.public_ip}:9090
     SSH: ubuntu@${aws_eip.web.public_ip}
  
  ⏱️ زمان ایجاد / Creation Time: ${timestamp()}
  
  =====================================================
  
  💡 نکته: منتظر بمانید تا سرور راه‌اندازی شود (حدود 5-10 دقیقه)
  💡 Note: Wait for server initialization (about 5-10 minutes)
  
  EOT
}

# ====================================================================
# اطلاعات هزینه (تخمینی) - Cost Information (Estimated)
# ====================================================================

# تخمین هزینه ماهانه - Monthly cost estimate
output "estimated_monthly_cost" {
  description = "تخمین هزینه ماهانه - Estimated monthly cost"
  value = <<-EOT
  
  💰 تخمین هزینه ماهانه / Estimated Monthly Cost:
  ================================================
  
  🖥️ EC2 Instance (${aws_instance.web.instance_type}):
     Free Tier: 750 ساعت رایگان / 750 hours free
     پس از Free Tier / After Free Tier: ~$8.50/month
  
  🗄️ RDS Database (${aws_db_instance.main.instance_class}):
     Free Tier: 750 ساعت رایگان / 750 hours free
     پس از Free Tier / After Free Tier: ~$15/month
  
  💾 Storage (${aws_db_instance.main.allocated_storage} GB):
     Free Tier: 20 GB رایگان / 20 GB free
     پس از Free Tier / After Free Tier: ~$2/month
  
  📡 Data Transfer:
     Free Tier: 1 GB رایگان / 1 GB free
     تخمینی / Estimated: ~$1/month
  
  ================================================
  جمع تخمینی / Total Estimate: 
     با Free Tier / With Free Tier: $0/month ✅
     بدون Free Tier / Without Free Tier: ~$26.50/month
  ================================================
  
  EOT
}