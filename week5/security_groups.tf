resource "aws_security_group" "SshSecurityGroup" {
  depends_on = [
    aws_vpc.aws_course_vpc,
  ]
  name        = "SshSecurityGroup"
  description = "Allow ssh inbound/outbound traffic"
  vpc_id = aws_vpc.aws_course_vpc.id

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

resource "aws_security_group" "SQSSecurityGroup" {
  depends_on = [
    aws_vpc.aws_course_vpc,
  ]
  name          = "SQSSecurityGroup"
  description   = "SQS"
  vpc_id        = aws_vpc.aws_course_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}