# VPC
# Create a VPC
resource "aws_vpc" "SoftServe-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "SoftServe-vpc"
  }
}

# Create 2 subnets
resource "aws_subnet" "SoftServe-2a" {
  vpc_id            = aws_vpc.SoftServe-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "SoftServe-2a"
  }
}

resource "aws_subnet" "SoftServe-2b" {
  vpc_id            = aws_vpc.SoftServe-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "SoftServe-2b"
  }
}

# Internet Gataway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.SoftServe-vpc.id

  tags = {
    "Name" = "Internet Gateway"
  }

  lifecycle {
    prevent_destroy = false
  }

  depends_on = [
    aws_vpc.SoftServe-vpc
  ]
}

# Route tables to route traffic for Public Subnet
resource "aws_route_table" "rt-public" {
  vpc_id = aws_vpc.SoftServe-vpc.id

  tags = {
    "Name" = "rt-public"
  }
}

# --------------------
# Load Balancer
resource "aws_lb" "balancing" {
  name               = "balancing-lb"
  internal           = false
  load_balancer_type = "network"

  # subnets = [aws_subnet.SoftServe-2a, aws_subnet.SoftServe-2b]

  subnet_mapping {
    subnet_id = aws_subnet.SoftServe-2a.id
    #private_ipv4_address = aws_subnet.SoftServe-2a
  }

  subnet_mapping {
    subnet_id = aws_subnet.SoftServe-2a.id
    #private_ipv4_address  = aws_subnet.SoftServe-2b
  }

  #security_groups            = [aws_security_group.sg_lb.id]
  enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
}


# --------------------
# NACL -> traffic between instances and the LB
resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.SoftServe-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "10.3.0.0/18"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.3.0.0/18"
    from_port  = 80
    to_port    = 80
  }

  tags = {
    Name = "main"
  }
}
