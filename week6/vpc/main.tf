resource "aws_vpc" "aws_course_vpc" {
  cidr_block              = "10.0.0.0/16"
  enable_dns_hostnames    = true
  enable_dns_support      = true

  tags = {
    Terraform             = "true"
    Environment           = "dev"
  }
}

resource "aws_subnet" "public_subnet_1" {
  depends_on = [
    aws_vpc.aws_course_vpc,
  ]
  vpc_id                  = aws_vpc.aws_course_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.AZ1
  map_public_ip_on_launch = true

  tags = {
    Name                  = "public_subnet_1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  depends_on = [
    aws_vpc.aws_course_vpc,
  ]
  vpc_id                  = aws_vpc.aws_course_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = var.AZ2
  map_public_ip_on_launch = true

  tags = {
    Name                  = "public_subnet_2"
  }
}

resource "aws_subnet" "private_subnet_1" {
  depends_on = [
    aws_vpc.aws_course_vpc,
  ]
  vpc_id                  = aws_vpc.aws_course_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = var.AZ1
  map_public_ip_on_launch = false

  tags = {
    Name                  = "private_subnet_1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  depends_on = [
    aws_vpc.aws_course_vpc,
  ]
  vpc_id                  = aws_vpc.aws_course_vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = var.AZ2
  map_public_ip_on_launch = false

  tags = {
    Name                  = "private_subnet_2"
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

resource "aws_route_table" "public" {
  vpc_id        = aws_vpc.aws_course_vpc.id
  route {
    cidr_block  = "0.0.0.0/0"
    gateway_id  = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table" "private" {
  vpc_id         = aws_vpc.aws_course_vpc.id
  route {
    cidr_block   = "0.0.0.0/0"
    instance_id  = var.ec2NatId
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private.id
}

data "aws_vpc_endpoint_service" "sqs" {
  service = "sqs"
}

data "aws_vpc_endpoint_service" "dynamodb" {
  service = "dynamodb"
}

data "aws_vpc_endpoint_service" "s3" {
  service = "s3"
  service_type = "Gateway"
}

data "aws_vpc_endpoint_service" "sns" {
  service = "sns"
}

resource "aws_vpc_endpoint" "sqs" {

  vpc_id              = aws_vpc.aws_course_vpc.id
  service_name        = data.aws_vpc_endpoint_service.sqs.service_name
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  security_group_ids  = [aws_security_group.SshSecurityGroup.id, aws_security_group.SQSSecurityGroup.id]
  subnet_ids          = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
}

resource "aws_vpc_endpoint" "sns" {

  vpc_id              = aws_vpc.aws_course_vpc.id
  service_name        = data.aws_vpc_endpoint_service.sns.service_name
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  security_group_ids  = [aws_security_group.SshSecurityGroup.id, aws_security_group.SQSSecurityGroup.id]
  subnet_ids          = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]
}

resource "aws_vpc_endpoint" "dynamodb" {

  vpc_id              = aws_vpc.aws_course_vpc.id
  service_name        = data.aws_vpc_endpoint_service.dynamodb.service_name
  vpc_endpoint_type   = "Gateway"

  route_table_ids = [
    aws_route_table.private.id,
    aws_route_table.public.id
  ]
}

resource "aws_vpc_endpoint" "s3_end" {

  vpc_id              = aws_vpc.aws_course_vpc.id
  service_name        = data.aws_vpc_endpoint_service.s3.service_name
  vpc_endpoint_type   = "Gateway"

  route_table_ids = [
    aws_route_table.private.id,
    aws_route_table.public.id
  ]
}