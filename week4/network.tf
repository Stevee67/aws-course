resource "aws_vpc" "aws_course_vpc" {
  cidr_block              = "10.0.0.0/16"
  enable_dns_hostnames    = true

  tags = {
    Terraform             = "true"
    Environment           = "dev"
  }
}

resource "aws_subnet" "private_subnet" {
  depends_on = [
    aws_vpc.aws_course_vpc,
  ]
  vpc_id                  = aws_vpc.aws_course_vpc.id
  cidr_block              = cidrsubnet("10.0.0.0/16", 12, 1)
  availability_zone       = var.AZ
  map_public_ip_on_launch = false

  tags = {
    Name                  = "private_subnet"
  }
}

resource "aws_subnet" "public_subnet" {
  depends_on = [
    aws_vpc.aws_course_vpc,
  ]
  vpc_id                  = aws_vpc.aws_course_vpc.id
  cidr_block              = cidrsubnet("10.0.0.0/16", 12, 0)
  availability_zone       = var.AZ2
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