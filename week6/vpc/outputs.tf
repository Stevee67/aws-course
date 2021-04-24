output "vpc_cidr_block" {
  description = "VPC cidr_block"
  value       = aws_vpc.aws_course_vpc.cidr_block
}

output "vpc_id" {
  description = "VPC id"
  value       = aws_vpc.aws_course_vpc.id
}

output "public_subnet_1_id" {
  description = "Public subnet 1 id"
  value       = aws_subnet.public_subnet_1.id
}

output "public_subnet_2_id" {
  description = "Public subnet 2 id"
  value       = aws_subnet.public_subnet_2.id
}

output "private_subnet_1_id" {
  description = "Private subnet 1 id"
  value       = aws_subnet.private_subnet_1.id
}

output "private_subnet_2_id" {
  description = "Private subnet 2 id"
  value       = aws_subnet.private_subnet_2.id
}

output "gateway_id" {
  value = aws_internet_gateway.gw.id
}