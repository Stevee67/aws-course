output "elb_host" {
  description = "Load balancer dns name"
  value       = aws_lb.testLb.dns_name
}

output "privateSecurityGroupId" {
  description = "Private security group"
  value       = aws_security_group.PrivateSecurityGroup.id
}


output "ec2NatId" {
  value       = aws_instance.ec2Nat.id
}