resource "aws_db_instance" "sshyshtest" {
  vpc_security_group_ids              = [aws_security_group.PostgresqlGr.id]
  name                                = var.RDSDbName
  allocated_storage                   = var.AllocatedStorage
  engine                              = var.DbEngine
  engine_version                      = var.DbEngineVersion
  identifier                          = var.RDSDbIdentifier
  iam_database_authentication_enabled = true
  storage_type                        = var.RDSStorageType
  instance_class                      = var.RdsInstanceType
  skip_final_snapshot                 = true
  username                            = var.DbUsername
  password                            = var.DbPassword
  availability_zone                   = var.AZ
  db_subnet_group_name = aws_db_subnet_group.db_subnet.name
}

resource "aws_db_subnet_group" "db_subnet" {
  name       = "main"
  subnet_ids = [var.DbSubnet1, var.DbSubnet2]

  tags = {
    Name = "My DB subnet group"
  }
}