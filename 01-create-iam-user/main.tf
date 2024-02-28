terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "terraform-remote-state-0001"
    key            = "terraform-remote-state-0001/remote/iam/terraform.tfstate"
    encrypt        = true
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_iam_user" "jay" {
  name = "jay"
}

resource "aws_iam_user_policy_attachment" "s3_access" {
  user       = aws_iam_user.jay.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}


resource "aws_iam_access_key" "keys" {
  user = aws_iam_user.jay.name
}


output "created_iam_user" {
  value = aws_iam_user.jay.arn
}


output "create_access_key" {
  value     = { "access_key" : aws_iam_access_key.keys.id, "secret_access_key" : aws_iam_access_key.keys.secret }
  sensitive = true
}

