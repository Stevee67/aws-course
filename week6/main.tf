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
}