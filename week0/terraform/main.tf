terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_instance" "MyEC2Instance" {
  ami             = var.AmiId
  instance_type   = var.InstanceType
  key_name        = var.KeyName
  security_groups = [aws_security_group.SshSecurityGroup.name]
}

resource "aws_security_group" "SshSecurityGroup" {
  name        = "SshSecurityGroup"
  description = "Allow ssh inbound traffic"

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}