resource "aws_security_group" "PostgresqlGr" {
  name = "PostgresqlGr"

  vpc_id = var.VpcId

  # inbound access
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    security_groups = [
      var.privateSecurityGroupId
    ]
  }
}