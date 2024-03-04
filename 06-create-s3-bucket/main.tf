terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "terraform-remote-state-0001"
    key            = "remote/create-s3/terraform.tfstate"
    encrypt        = true
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "aws_s3_test_bucket_001" {
  bucket = "aws-s3-test-bucket-001"
}

output "s3_info" {
  value = aws_s3_bucket.aws_s3_test_bucket_001.id
}
