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

resource "aws_security_group" "SshSecurityGroup" {
  name        = "SshSecurityGroup"
  description = "Allow ssh inbound/outbound traffic"

  ingress {
    description = "SSH inbound access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "SSH outbound access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "HttpSecurityGroup" {
  name        = "HttpSecurityGroup"
  description = "Allow http inbound/outbound traffic"

  ingress {
    description = "Http inbound access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Http outbound access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "HttpsSecurityGroup" {
  name        = "HttpsSecurityGroup"
  description = "Allow https inbound/outbound traffic"

  ingress {
    description = "Http inbound access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Http outbound access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_template" "testLaunchTemplate" {
  name = "testLaunchTemplate"
  image_id = var.AmiId
  instance_type = var.InstanceType
  key_name = var.KeyName
  security_group_names = [
    aws_security_group.SshSecurityGroup.name,
    aws_security_group.HttpSecurityGroup.name,
    aws_security_group.HttpsSecurityGroup.name
  ]
  user_data = base64encode(data.template_file.user_data.rendered)
}

resource "aws_autoscaling_group" "testASG" {
  name = "testASG"
  max_size = 2
  min_size = 2
  desired_capacity = 2
  health_check_grace_period = 300
  availability_zones = ["us-west-2a"]
  launch_template {
    id      = aws_launch_template.testLaunchTemplate.id
    version = aws_launch_template.testLaunchTemplate.latest_version
  }
}

data "template_file" "user_data" {
  template = file("templates/user_data.tpl")
}