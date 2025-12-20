# Outputs - Infrastructure Information

# ====================================================================
# Server Information
# ====================================================================

output "web_server_public_ip" {
  description = "Web server public IP address"
  value       = aws_eip.web.public_ip
}

output "web_server_private_ip" {
  description = "Web server private IP address"
  value       = aws_instance.web.private_ip
}

output "web_server_instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.web.id
}

output "web_server_instance_type" {
  description = "EC2 instance type"
  value       = aws_instance.web.instance_type
}

output "web_server_availability_zone" {
  description = "Server availability zone"
  value       = aws_instance.web.availability_zone
}
output "application_url" {
  description = "URL to access the web application"
  value       = "http://${aws_eip.web.public_ip}:9090"
}
# ====================================================================
# Database Information
# ====================================================================

output "database_endpoint" {
  description = "Database connection endpoint"
  value       = aws_db_instance.main.endpoint
}

output "database_host" {
  description = "Database host address"
  value       = aws_db_instance.main.address
}

output "database_port" {
  description = "Database port"
  value       = aws_db_instance.main.port
}

output "database_name" {
  description = "Database name"
  value       = aws_db_instance.main.db_name
}

output "database_identifier" {
  description = "RDS instance identifier"
  value       = aws_db_instance.main.identifier
}

# ====================================================================
# Network Information
# ====================================================================

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "VPC CIDR block"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_1_id" {
  description = "Public subnet 1 ID"
  value       = aws_subnet.public_1.id
}

output "public_subnet_2_id" {
  description = "Public subnet 2 ID"
  value       = aws_subnet.public_2.id
}

# ====================================================================
# Security Information
# ====================================================================

output "web_security_group_id" {
  description = "Web server security group ID"
  value       = aws_security_group.web_server.id
}

output "database_security_group_id" {
  description = "Database security group ID"
  value       = aws_security_group.database.id
}

# ====================================================================
# Access Information
# ====================================================================

output "application_url" {
  description = "Web application URL"
  value       = "http://${aws_eip.web.public_ip}:9090"
}

output "ssh_connection_command" {
  description = "SSH command to connect to server"
  value       = "ssh -i ~/.ssh/id_rsa ubuntu@${aws_eip.web.public_ip}"
}
# Test CI/CD Trigger