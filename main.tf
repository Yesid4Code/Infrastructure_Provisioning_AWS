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
  vpc_security_group_ids = [aws_security_group.SoftServe-sg.id] ## PENDIENTE
  subnet_id              = aws_subnet.SoftServe-2a.id

  # key_name  = "first_ec2"
  user_data = file("server_setup.sh")

  tags = {
    Name = "web_server_ec2-1"
  }
}

resource "aws_instance" "web_server_ec2_2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.SoftServe-sg.id] ## PENDIENTE
  subnet_id              = aws_subnet.SoftServe-2b.id

  # key_name  = "first_ec2"
  user_data = file("server_setup.sh")

  tags = {
    Name = "web_server_ec2-2"
  }
}
