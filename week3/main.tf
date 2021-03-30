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

resource "aws_launch_template" "testLaunchTemplate" {
  name = "testLaunchTemplate"
  image_id = var.AmiId
  instance_type = var.InstanceType
  key_name = var.KeyName
  vpc_security_group_ids = [
    aws_security_group.SshSecurityGroup.id,
    aws_security_group.HttpSecurityGroup.id,
  ]
  iam_instance_profile {arn = aws_iam_instance_profile.InstanceProfile.arn}
  user_data = base64encode(data.template_file.user_data.rendered)
}

resource "aws_iam_instance_profile" "InstanceProfile" {
  path = "/"
  role = aws_iam_role.EC2Role.name
}

resource "aws_iam_role" "EC2Role" {
  name = "S3BucketsRole"
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

resource "aws_autoscaling_group" "testASG" {
  name = var.AsgName
  max_size = var.AsgMinSize
  min_size = var.AsgMaxSize
  desired_capacity = var.AsgDesiredCapacity
  health_check_grace_period = 300
  availability_zones = [var.AZ]
  launch_template {
    id      = aws_launch_template.testLaunchTemplate.id
    version = aws_launch_template.testLaunchTemplate.latest_version
  }
}

resource "aws_dynamodb_table" "first-dynamodb-table" {
  name = "Table1"
  read_capacity = var.DynamoDbReadCapacity
  write_capacity = var.DynamoDbWriteCapacity
  hash_key = "UserId"

  attribute {
    name = "UserId"
    type = "S"
  }
}


resource "aws_db_instance" "sshyshtest" {
  vpc_security_group_ids              = [aws_security_group.PostgresqlGr.id]
  name                                = var.RDSDbName
  allocated_storage                   = var.AllocatedStorage
  engine                              = var.DbEngine
  engine_version                      = var.DbEngineVersion
  identifier                          = var.RDSDbIdentifier
  iam_database_authentication_enabled = true
  storage_type                        = var.RDSStorageType
  instance_class                      = var.RdsInstanceType
  skip_final_snapshot                 = true
  username                            = var.DbUsername
  password                            = var.DbPassword
  availability_zone                   = var.AZ
}

data "template_file" "user_data" {
  template = file("templates/user_data.tpl")
}