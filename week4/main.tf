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
    aws_security_group.HttpSecurityGroup,
    aws_security_group.SshSecurityGroup,
  ]
  instance_type          = var.InstanceType
  key_name               = var.KeyName
  subnet_id              = aws_subnet.public_subnet.id
  availability_zone      = var.AZ2
  iam_instance_profile   = aws_iam_instance_profile.InstanceProfile.name
  ami                    = var.AmiId
  vpc_security_group_ids = [aws_security_group.HttpSecurityGroup.id, aws_security_group.SshSecurityGroup.id]
  user_data              = base64encode(data.template_file.user_data.rendered)
}


resource "aws_instance" "ec2Private" {
  tags = {
    Name: "ec2Private"
  }
  instance_type          = var.InstanceType
  key_name               = var.KeyName
  subnet_id              = aws_subnet.private_subnet.id
  availability_zone      = var.AZ
  iam_instance_profile   = aws_iam_instance_profile.InstanceProfile.name
  ami                    = var.AmiId
  vpc_security_group_ids = [aws_security_group.PrivateSecurityGroup.id]
  user_data              = base64encode(data.template_file.user_data_private.rendered)
}

resource "aws_instance" "ec2Nat" {
  depends_on = [
    aws_security_group.HttpSecurityGroup,
    aws_security_group.SshSecurityGroup,
  ]
  tags = {
    Name: "ec2Nat"
  }
  instance_type          = var.InstanceType
  key_name               = var.KeyName
  subnet_id              = aws_subnet.public_subnet.id
  availability_zone      = var.AZ2
  iam_instance_profile   = aws_iam_instance_profile.InstanceProfile.name
  ami                    = var.NatAmiId
  vpc_security_group_ids = [aws_security_group.HttpSecurityGroup.id, aws_security_group.SshSecurityGroup.id]
  source_dest_check      = false
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

data "template_file" "user_data" {
  template                   = file("templates/user_data.tpl")
  vars = {
    subnet                   = "public"
  }
}

data "template_file" "user_data_private" {
  template                   = file("templates/user_data.tpl")
  vars = {
    subnet                   = "private"
  }
}

resource "aws_lb_target_group" "testTargetGroup" {
  name                       = "tf-test-lb-tg"
  port                       = 80
  protocol                   = "HTTP"
  vpc_id                     = aws_vpc.aws_course_vpc.id
  health_check {
    healthy_threshold        = var.HealthyThreshold
    unhealthy_threshold      = var.UnHealthyThreshold
    timeout                  = var.HealthCheckTimeout
    interval                 = var.HealthCheckInterval
    path                     = "/index.html"
  }
}

resource "aws_lb_target_group_attachment" "lbPublic" {
  target_group_arn           = aws_lb_target_group.testTargetGroup.arn
  target_id                  = aws_instance.ec2Public.id
  port                       = 80
}

resource "aws_lb_target_group_attachment" "lbPrivate" {
  target_group_arn           = aws_lb_target_group.testTargetGroup.arn
  target_id                  = aws_instance.ec2Private.id
  port                       = 80
}

resource "aws_lb" "testLb" {
  name                       = "test-lb-tf"
  internal                   = false
  ip_address_type            = "ipv4"
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.HttpSecurityGroup.id]
  subnets                    = [aws_subnet.public_subnet.id, aws_subnet.private_subnet.id]
  enable_deletion_protection = false
  tags = {
    Environment              = "dev"
  }
}

resource "aws_lb_listener" "testListener" {
  load_balancer_arn          = aws_lb.testLb.arn
  port                       = "80"
  protocol                   = "HTTP"

  default_action {
    type                     = "forward"
    target_group_arn         = aws_lb_target_group.testTargetGroup.arn
  }
}