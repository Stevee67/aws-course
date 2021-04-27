output "db_endpoint" {
  description = "DB Instance endpoint"
  value       = aws_db_instance.sshyshtest.address
}

output "db_port" {
  description = "DB Instance address"
  value       = aws_db_instance.sshyshtest.port
}