terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "terraform-remote-state-0001"
    key            = "terraform-remote-state-00001/remote/iam-group/terraform.tfstate"
    encrypt        = true
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_iam_group" "dev_group" {
  name = "dev"
}

resource "aws_iam_group_policy_attachment" "s3_permission" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  group      = aws_iam_group.dev_group.name
}

resource "aws_iam_user" "jay_user" {
  name = "jay"
}

resource "aws_iam_user_group_membership" "add_user_to_dev_group" {
  user   = aws_iam_user.jay_user.name
  groups = [aws_iam_group.dev_group.name]
}

output "dev_group_id" {
  description = "The ID of the dev IAM group"
  value       = aws_iam_group.dev_group.id
}

output "jay_user_name" {
  description = "The name of the IAM user 'jay'"
  value       = aws_iam_user.jay_user.name
}

