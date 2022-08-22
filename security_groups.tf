# Default Security Group
resource "aws_default_security_group" "default-sg" {
  vpc_id = aws_vpc.SoftServe_vpc.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Default-sg"
  }

  depends_on = [aws_vpc.SoftServe_vpc]
}

# EC2 Security Group
resource "aws_security_group" "SoftServe-sg" {
  name        = "SoftServe-sg"
  description = "Security group for EC2 instances"
  vpc_id      = aws_vpc.SoftServe_vpc.id

  tags = {
    Name = "SoftServe-sg"
  }
}

resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.SoftServe-sg.id
  description       = "Allow connections to HTTP port from any IP"

  depends_on = [aws_security_group.SoftServe-sg]
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.SoftServe-sg.id
  description       = "Allow connections to the SSH port from any IP"

  depends_on = [aws_security_group.SoftServe-sg]
}

resource "aws_security_group_rule" "Alll" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.SoftServe-sg.id ##¡ ???????
  description       = "Allow connections out of the VPC"

  depends_on = [aws_security_group.SoftServe-sg]
}
