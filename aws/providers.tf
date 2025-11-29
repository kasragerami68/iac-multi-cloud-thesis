# تنظیمات Terraform و Providers
# Terraform and Provider Configuration

# تنظیمات اصلی Terraform - Main Terraform configuration
terraform {
  # حداقل نسخه مورد نیاز - Minimum required version
  required_version = ">= 1.0"
  
  # Providers مورد نیاز - Required providers
  required_providers {
    # AWS Provider
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  # نسخه 5.x - Version 5.x
    }
  }
}

# تنظیمات AWS Provider - AWS Provider configuration
provider "aws" {
  # منطقه جغرافیایی - Geographic region
  region = var.aws_region
  
  # تگ‌های پیش‌فرض برای تمام منابع - Default tags for all resources
  default_tags {
    tags = var.common_tags
  }
}