output "elb_host" {
  description = "Load balancer dns name"
  value       = module.ec2.elb_host
}
output "rds_db_endpoint" {
  description = "Rds db endpoint"
  value       = module.rds.db_endpoint
}
output "rds_db_port" {
  description = "Rds db port"
  value       = module.rds.db_port
}