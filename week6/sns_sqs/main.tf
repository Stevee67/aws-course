resource "aws_sqs_queue" "terraform_queue" {
  name                        = var.SQSQueueName
  visibility_timeout_seconds  = 60
}

resource "aws_sns_topic" "send_email" {
  name = var.SNSTopicName
}