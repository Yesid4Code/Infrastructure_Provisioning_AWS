# empieza
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  required_version = ">=1.2.0"
}

provider "aws" {
  region = "us-east-2"
}

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

  # ---------------
# Create the AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Create 2 EC2 instances with a server
resource "aws_instance" "web_server_ec2_1" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [ "aws_security_group" ] ## PENDIENTE
  subnet_id = aws_subnet.soft-test-subnet-1a

  key_name = "first_ec2"
  user_data = "${file("install_apache.sh")}"


  tags = {
    Name = "web_server_ec2-1"
  }
}

resource "aws_instance" "web_server_ec2_2" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [ "aws_security_group" ] ## PENDIENTE
  subnet_id = aws_subnet.soft-test-subnet-1a

  key_name = "first_ec2"
  user_data = "${file("install_apache.sh")}"


  tags = {
    Name = "web_server_ec2-2"
  }
}

# --------------------
# Load Balancer




# --------------------
# NACL -> Comunica con las instancias y con el LB
resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.main.id

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
