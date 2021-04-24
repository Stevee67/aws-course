output "elb_host" {
  description = "Load balancer dns name"
  value       = module.ec2.elb_host
}