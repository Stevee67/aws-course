output "elb_host" {
  description = "Load balancer dns name"
  value       = aws_lb.testLb.dns_name
}