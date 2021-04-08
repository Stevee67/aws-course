resource "aws_route_table" "public" {
  vpc_id        = aws_vpc.aws_course_vpc.id
  depends_on    = [
    aws_vpc.aws_course_vpc,
    aws_internet_gateway.gw,
  ]
  route {
    cidr_block  = "0.0.0.0/0"
    gateway_id  = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table" "private" {
  vpc_id        = aws_vpc.aws_course_vpc.id
  depends_on    = [
    aws_vpc.aws_course_vpc,
    aws_iam_role.EC2Role,
  ]
  route {
    cidr_block   = "0.0.0.0/0"
    instance_id  = aws_instance.ec2Nat.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public.id
  depends_on     = [
    aws_subnet.public_subnet,
    aws_route_table.public,
  ]
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private.id
  depends_on     = [
    aws_subnet.private_subnet,
    aws_route_table.private,
  ]
}