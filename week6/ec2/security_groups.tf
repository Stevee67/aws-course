resource "aws_security_group" "SshSecurityGroupEC2" {
  name        = "SshSecurityGroupEC2"
  description = "Allow ssh inbound/outbound traffic"
  vpc_id      = var.VpcId

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
  vpc_id      = var.VpcId

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
  vpc_id      = var.VpcId

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


resource "aws_security_group" "PrivateSecurityGroup" {
  name        = "PrivateSecurityGroup"
  description = "Allow http inbound/outbound traffic"
  vpc_id      = var.VpcId

  ingress {
    description = "SSH inbound access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Http inbound access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.HttpSecurityGroup.id]
  }

  ingress {
    description = "Http inbound access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.HttpSecurityGroup.id]
  }

  ingress {
    from_port = 8
    to_port = 0
    protocol = "icmp"
    security_groups = [aws_security_group.HttpSecurityGroup.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.HttpSecurityGroup.id]
  }
}