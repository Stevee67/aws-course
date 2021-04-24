resource "aws_route_table" "public" {
  vpc_id        = var.VpcId
  route {
    cidr_block  = "0.0.0.0/0"
    gateway_id  = var.GatewayId
  }
}

resource "aws_route_table" "private" {
  vpc_id         = var.VpcId
  route {
    cidr_block   = "0.0.0.0/0"
    instance_id  = aws_instance.ec2Nat.id
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = var.Public1SubnetId
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = var.Public2SubnetId
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = var.Private1SubnetId
  route_table_id = aws_route_table.private.id
}