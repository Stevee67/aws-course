output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_launch_template.testLaunchTemplate.network_interfaces
}

output "db_endpoint" {
  description = "DB Instance endpoint"
  value       = aws_db_instance.sshyshtest.endpoint
}

output "db_port" {
  description = "DB Instance address"
  value       = aws_db_instance.sshyshtest.port
}