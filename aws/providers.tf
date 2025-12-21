# Terraform and AWS Provider Configuration

terraform {
  required_version = ">= 1.0"
  
    backend "s3" {
    bucket         = "iac-thesis-terraform-state-397245851405"
    key            = "aws/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# AWS Provider
provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = var.common_tags
  }
}
# Test CI/CD Triggerr