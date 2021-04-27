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

module "vpc" {
  source = "./vpc"
  AZ1 = var.AZ1
  AZ2 = var.AZ2
  ec2NatId = module.ec2.ec2NatId
}

module "ec2" {
  source = "./ec2"
  AZ1 = var.AZ1
  AZ2 = var.AZ2
  AmiId = var.AmiId
  InstanceType = var.InstanceType
  KeyName = var.KeyName
  AsgMinSize = var.AsgMinSize
  AsgMaxSize = var.AsgMaxSize
  AsgDesiredCapacity = var.AsgDesiredCapacity
  AsgName = var.AsgName
  VpcId = module.vpc.vpc_id
  NatAmiId = var.NatAmiId
  Public1SubnetId = module.vpc.public_subnet_1_id
  Public2SubnetId = module.vpc.public_subnet_2_id
  Private1SubnetId = module.vpc.private_subnet_1_id
  Private2SubnetId = module.vpc.private_subnet_2_id
  HealthyThreshold = var.HealthyThreshold
  UnHealthyThreshold = var.UnHealthyThreshold
  HealthCheckTimeout = var.HealthCheckTimeout
  HealthCheckInterval = var.HealthCheckInterval
  GatewayId = module.vpc.gateway_id
  RdsHost = module.rds.db_endpoint
}

module "ddb" {
  source = "./ddb"
  DynamoDbReadCapacity = var.DynamoDbReadCapacity
  DynamoDbWriteCapacity = var.DynamoDbWriteCapacity
  DynamoDbName = var.DynamoDbName
}

module "sns_sqs" {
  source = "./sns_sqs"
  SNSTopicName = var.SNSTopicName
  SQSQueueName = var.SQSQueueName
}

module "rds" {
  source = "./rds"
  AllocatedStorage = var.AllocatedStorage
  RdsInstanceType = var.RdsInstanceType
  DbUsername = var.DbUsername
  DbPassword = var.DbPassword
  DbEngine = var.DbEngine
  DbEngineVersion = var.DbEngineVersion
  RDSStorageType = var.RDSStorageType
  RDSDbName = var.RDSDbName
  RDSDbIdentifier = var.RDSDbIdentifier
  privateSecurityGroupId = module.ec2.privateSecurityGroupId
  AZ = var.AZ1
  DbSubnet1 = module.vpc.private_subnet_1_id
  DbSubnet2 = module.vpc.private_subnet_2_id
  VpcId = module.vpc.vpc_id
}