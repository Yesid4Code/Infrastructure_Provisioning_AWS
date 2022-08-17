# Main
provider "aws" {
  region = "us-east-2"
}

# Create the AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Create 2 EC2 instances with a server
resource "aws_instance" "web_server_ec2_1" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["aws_security_group"] ## PENDIENTE
  subnet_id              = aws_subnet.SoftServe-2a.id

  key_name  = "first_ec2"
  user_data = file("install_apache.sh")


  tags = {
    Name = "web_server_ec2-1"
  }
}

resource "aws_instance" "web_server_ec2_2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["aws_security_group"] ## PENDIENTE
  subnet_id              = aws_subnet.SoftServe-2b

  key_name  = "first_ec2"
  user_data = file("install_apache.sh")


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
