# Project Variables

# Project name for resource naming
variable "project_name" {
  description = "Project name used for naming resources"
  type        = string
  default     = "iac-web-app"
}

# Environment (dev, staging, prod)
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

# AWS Region
variable "aws_region" {
  description = "AWS geographic region"
  type        = string
  default     = "us-east-1"
}

# EC2 Instance Type
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

# Database Username
variable "db_username" {
  description = "MySQL database username"
  type        = string
  default     = "kasra"
  sensitive   = true
}

# Database Password
variable "db_password" {
  description = "MySQL database password"
  type        = string
  default     = "test1234"
  sensitive   = true
}

# Database Name
variable "db_name" {
  description = "Database name"
  type        = string
  default     = "community_db"
}

# Database Instance Type
variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

# Database Storage Size (GB)
variable "db_allocated_storage" {
  description = "Database storage in GB"
  type        = number
  default     = 20
}

# Common Resource Tags
variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Project     = "IaC-Multi-Cloud-Thesis"
    ManagedBy   = "Terraform"
    Owner       = "Kasra Gerami"
    University  = "University of Northampton"
  }
}
# Test CI/CD Trigger"" 
