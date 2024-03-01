// this is not recommend for prod env due to security risk

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "terraform-remote-state-0001"
    key            = "terraform-remote-state-0001/remote/ec2/key-pair/terraform.tfstate"
    encrypt        = true
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "tls_private_key" "rsa_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "aws_ssh_key" {
  key_name   = "pop_os_ssh_key"
  public_key = tls_private_key.rsa_key.public_key_openssh
}

output "ssh_key" {
  value     = tls_private_key.rsa_key.private_key_pem
  sensitive = true
}

resource "local_sensitive_file" "pem_file" {
  filename             = pathexpand("~/.ssh/aws-pop-os")
  file_permission      = "600"
  directory_permission = "700"
  content              = tls_private_key.rsa_key.private_key_pem
}
