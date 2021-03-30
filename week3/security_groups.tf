resource "aws_security_group" "SshSecurityGroup" {
  name        = "SshSecurityGroup"
  description = "Allow ssh inbound/outbound traffic"

  ingress {
    description = "SSH inbound access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "SSH outbound access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "HttpSecurityGroup" {
  name        = "HttpSecurityGroup"
  description = "Allow http inbound/outbound traffic"

  ingress {
    description = "Http inbound access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Http outbound access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "HttpsSecurityGroup" {
  name        = "HttpsSecurityGroup"
  description = "Allow https inbound/outbound traffic"

  ingress {
    description = "Http inbound access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Http outbound access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "PostgresqlGr" {
  name = "PostgresqlGr"

  ingress {
      description = "RDS inbound access"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
}