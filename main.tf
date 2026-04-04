terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# A guaranteed new S3 bucket (change the name to something unique)
resource "aws_s3_bucket" "demo" {
  bucket = "bijil-test-terraform-bucket-9876543210"

  tags = {
    Name        = "Demo Bucket"
    Environment = "Dev"
  }
}