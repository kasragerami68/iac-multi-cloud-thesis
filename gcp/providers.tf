terraform {
  required_version = ">= 1.0"
  backend "s3" {
    bucket         = "iac-thesis-terraform-state-397245851405"
    key            = "gcp/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}
# Test CI/CD Triggerr