
output "ec2_ip" {
  description = "EC2 instance public IP"
  value       = aws_instance.ec2Public.public_ip
}

output "sqs_queue_url" {
  description = "SQS queue url"
  value       = aws_sqs_queue.terraform_queue.id
}
