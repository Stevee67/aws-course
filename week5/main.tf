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
  region  = var.AWSRegion
}


resource "aws_instance" "ec2Public" {
  tags = {
    Name: "ec2Public"
  }
  depends_on = [
    aws_security_group.SshSecurityGroup,
  ]
  associate_public_ip_address = true
  instance_type          = var.InstanceType
  key_name               = var.KeyName
  subnet_id              = aws_subnet.public_subnet.id
  availability_zone      = var.AZ
  iam_instance_profile   = aws_iam_instance_profile.InstanceProfile.name
  ami                    = var.AmiId
  vpc_security_group_ids = [aws_security_group.SshSecurityGroup.id, aws_security_group.SQSSecurityGroup.id]
}

resource "aws_iam_instance_profile" "InstanceProfile" {
  path = "/"
  role = aws_iam_role.EC2Role.name
}

resource "aws_iam_role" "EC2Role" {
  name = "EC2Role"
  assume_role_policy = jsonencode(
      {
          "Version": "2012-10-17",
          "Statement": [
              {
                  Action: "sts:AssumeRole",
                  Principal: {
                     "Service": "ec2.amazonaws.com"
                  },
                  Effect: "Allow",
              }
          ]
      }
  )
  path = "/"
}


resource "aws_sqs_queue" "terraform_queue" {
  name                        = "terraform-example-queue"
  visibility_timeout_seconds  = 60
}

resource "aws_sns_topic" "send_email" {
  name = "send-email"
}