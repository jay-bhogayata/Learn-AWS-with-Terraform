terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws",
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "terraform-remote-state-0001"
    key            = "terraform-remote-state-0001/remote/ec2/terraform.tfstate"
    encrypt        = true
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
  }
}

provider "aws" {
  region = "ap-south-1"
}

data "aws_ami" "ubutnu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "web_server" {
  ami           = data.aws_ami.ubutnu.id
  instance_type = "t2.micro"

  tags = {
    Name = "web_server"
  }
}

output "ec2_instance_public_ip" {
  value = aws_instance.web_server.public_ip
}
