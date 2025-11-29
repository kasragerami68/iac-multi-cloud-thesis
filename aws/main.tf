# تنظیمات Terraform
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# تنظیمات AWS Provider
provider "aws" {
  region = "us-east-1"
}

# ساخت یک S3 Bucket برای تست
resource "aws_s3_bucket" "test_bucket" {
  bucket = "kasra-thesis-test-bucket-${formatdate("YYYYMMDD", timestamp())}"
  
  tags = {
    Name        = "Thesis Test Bucket"
    Environment = "Development"
    Project     = "IaC Multi-Cloud"
    ManagedBy   = "Terraform"
  }
}

# تنظیمات امنیتی - Block Public Access
resource "aws_s3_bucket_public_access_block" "test_bucket" {
  bucket = aws_s3_bucket.test_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}