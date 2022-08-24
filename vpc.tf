# VPC
resource "aws_vpc" "SoftServe_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "SoftServe_vpc"
  }
}

# Internet Gataway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.SoftServe_vpc.id

  depends_on = [
    aws_vpc.SoftServe_vpc
  ]

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    "Name" = "Internet Gateway"
  }
}

# Route tables to route traffic for Public Subnet
resource "aws_route_table" "rt_main" {
  vpc_id = aws_vpc.SoftServe_vpc.id

  # route { cidr_block = 10.0.0.0/16 target local}
  route {
    cidr_block = "0.0.0.0/0" # To send all traffic to all internet
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.igw.id
  }

  tags = {
    "Name" = "rt_main"
  }
}

# Create 2 subnets
resource "aws_subnet" "subnet_2a" {
  vpc_id            = aws_vpc.SoftServe_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "SoftServe-2a"
  }
}

resource "aws_subnet" "subnet_2b" {
  vpc_id            = aws_vpc.SoftServe_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "SoftServe-2b"
  }
}

# Associate route table
resource "aws_route_table_association" "_2a" {
  subnet_id      = aws_subnet.subnet_2a.id
  route_table_id = aws_route_table.rt_main.id
}

resource "aws_route_table_association" "_2b" {
  subnet_id      = aws_subnet.subnet_2b.id
  route_table_id = aws_route_table.rt_main.id
}

# Network Load Balancer

resource "aws_lb" "NLB" {
  name               = "NLB"
  internal           = false
  load_balancer_type = "network"

  subnets = [aws_subnet.subnet_2a.id, aws_subnet.subnet_2b.id]

  depends_on = [aws_instance.web_server_ec2_2a, aws_instance.web_server_ec2_2b]

  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true

  tags = {
    Environment = "NLB"
  }
}

resource "aws_lb_target_group" "NLB-target" {
  name        = "NLB-target"
  port        = 80
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = aws_vpc.SoftServe_vpc.id

  depends_on = [
    aws_lb.NLB
  ]
}

resource "aws_lb_target_group_attachment" "NLB-target-attached_2a" {
  target_group_arn = aws_lb_target_group.NLB-target.arn
  target_id        = aws_instance.web_server_ec2_2a.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "NLB-target-attached_2b" {
  target_group_arn = aws_lb_target_group.NLB-target.arn
  target_id        = aws_instance.web_server_ec2_2b.id
  port             = 80
}

# Listener
resource "aws_lb_listener" "front_end_80" {
  load_balancer_arn = aws_lb.NLB.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.NLB-target.arn
  }

  depends_on = [aws_lb_target_group.NLB-target]
}
