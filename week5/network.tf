resource "aws_vpc" "aws_course_vpc" {
  cidr_block              = "10.0.0.0/16"
  enable_dns_hostnames    = true
  enable_dns_support      = true

  tags = {
    Terraform             = "true"
    Environment           = "dev"
  }
}

resource "aws_subnet" "public_subnet" {
  depends_on = [
    aws_vpc.aws_course_vpc,
  ]
  vpc_id                  = aws_vpc.aws_course_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = var.AZ
  map_public_ip_on_launch = true

  tags = {
    Name                  = "public_subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  depends_on = [
    aws_vpc.aws_course_vpc,
  ]
  vpc_id                  = aws_vpc.aws_course_vpc.id
  tags = {
    Name                  = "main"
  }
}

data "aws_vpc_endpoint_service" "sqs" {
  service = "sqs"
}

resource "aws_vpc_endpoint" "sqs" {

  vpc_id              = aws_vpc.aws_course_vpc.id
  service_name        = data.aws_vpc_endpoint_service.sqs.service_name
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  security_group_ids  = [aws_security_group.SshSecurityGroup.id, aws_security_group.SQSSecurityGroup.id]
  subnet_ids          = [aws_subnet.public_subnet.id]
}
