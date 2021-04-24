resource "aws_launch_template" "testLaunchTemplate" {
  name = "testLaunchTemplate"
  image_id = var.AmiId
  instance_type = var.InstanceType
  key_name = var.KeyName
  vpc_security_group_ids = [
    aws_security_group.SshSecurityGroupEC2.id,
    aws_security_group.HttpSecurityGroup.id,
    aws_security_group.HttpsSecurityGroup.id
  ]
  iam_instance_profile {arn = aws_iam_instance_profile.InstanceProfile.arn}
  user_data              = base64encode(data.template_file.user_data.rendered)
}

resource "aws_iam_instance_profile" "InstanceProfile" {
  path = "/"
  role = aws_iam_role.InstanceRole.name
}

resource "aws_iam_role" "InstanceRole" {
  name = "InstanceRole"
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
resource "aws_instance" "ec2Private" {
  tags = {
    Name: "ec2Private"
  }
  instance_type          = var.InstanceType
  key_name               = var.KeyName
  subnet_id              = var.Private1SubnetId
  availability_zone      = var.AZ1
  iam_instance_profile   = aws_iam_instance_profile.PrivateInstanceProfile.name
  ami                    = var.AmiId
  vpc_security_group_ids = [aws_security_group.PrivateSecurityGroup.id]
  user_data              = base64encode(data.template_file.user_data_private.rendered)
}

resource "aws_iam_instance_profile" "PrivateInstanceProfile" {
  path = "/"
  role = aws_iam_role.PrivateInstanceRole.name
}

resource "aws_iam_role" "PrivateInstanceRole" {
  name = "PrivateInstanceRole"
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

resource "aws_instance" "ec2Nat" {
  tags = {
    Name: "ec2Nat"
  }
  instance_type          = var.InstanceType
  key_name               = var.KeyName
  subnet_id              = var.Public1SubnetId
  availability_zone      = var.AZ1
  iam_instance_profile   = aws_iam_instance_profile.InstanceProfile.name
  ami                    = var.NatAmiId
  vpc_security_group_ids = [aws_security_group.HttpSecurityGroup.id, aws_security_group.SshSecurityGroupEC2.id]
  source_dest_check      = false
}

resource "aws_autoscaling_group" "testASG" {
  name = var.AsgName
  max_size = var.AsgMaxSize
  min_size = var.AsgMinSize
  desired_capacity = var.AsgDesiredCapacity
  health_check_grace_period = 300
  vpc_zone_identifier       = [var.Public1SubnetId, var.Public2SubnetId]
  launch_template {
    id      = aws_launch_template.testLaunchTemplate.id
    version = aws_launch_template.testLaunchTemplate.latest_version
  }
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
  vpc_id                     = var.VpcId
  health_check {
    healthy_threshold        = var.HealthyThreshold
    unhealthy_threshold      = var.UnHealthyThreshold
    timeout                  = var.HealthCheckTimeout
    interval                 = var.HealthCheckInterval
    path                     = "/index.html"
  }
}


resource "aws_lb" "testLb" {
  name                       = "test-lb-tf"
  internal                   = false
  ip_address_type            = "ipv4"
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.HttpSecurityGroup.id]
  subnets                    = [var.Public1SubnetId, var.Public2SubnetId]
  enable_deletion_protection = false
  tags = {
    Environment              = "dev"
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.testASG.name
  alb_target_group_arn = aws_lb_target_group.testTargetGroup.arn
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