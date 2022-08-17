# VPC
# Create a VPC
resource "aws_vpc" "SoftServe-vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "SoftServe-vpc"
  }
}

# Create 2 subnets
resource "aws_subnet" "SoftServe-2a" {
  vpc_id = aws_vpc.SoftServe-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "SoftServe-2a"
  }
}

resource "aws_subnet" "SoftServe-2b" {
  vpc_id = aws_vpc.SoftServe-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "SoftServe-2b"
  }
}
