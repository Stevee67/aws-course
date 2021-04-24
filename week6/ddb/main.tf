resource "aws_dynamodb_table" "edu-lohika-training-aws-dynamodb" {
  name = var.DynamoDbName
  read_capacity = var.DynamoDbReadCapacity
  write_capacity = var.DynamoDbWriteCapacity
  hash_key = "UserName"

  attribute {
    name = "UserName"
    type = "S"
  }
}