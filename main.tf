
terraform {
  backend "s3" {
    bucket = "bijil-test-terraform-state"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create an S3 bucket
resource "aws_s3_bucket" "example" {
  bucket = "s3-bucket-terraform-9645"

  tags = {
    Name        = "dev-s3-bucket"
    Environment = "Dev"
  }
}