# Main
provider "aws" {
  region = "us-east-2" # Ohio
}

# Create 2 Network interfaces
resource "aws_network_interface" "ni_server_2a" {
  subnet_id       = aws_subnet.subnet_2a.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.SoftServe-sg.id]
}

resource "aws_network_interface" "ni_server_2b" {
  subnet_id       = aws_subnet.subnet_2b.id
  private_ips     = ["10.0.2.50"]
  security_groups = [aws_security_group.SoftServe-sg.id]
}

# Assign an elastic IP to the Network Interfaces
resource "aws_eip" "eip_2a" {
  vpc                       = true
  network_interface         = aws_network_interface.ni_server_2a.id
  associate_with_private_ip = "10.0.1.50"

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "eip_2b" {
  vpc                       = true
  network_interface         = aws_network_interface.ni_server_2b.id
  associate_with_private_ip = "10.0.2.50"

  depends_on = [aws_internet_gateway.igw]
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

# Create 2 EC2 instances with ubuntu server
resource "aws_instance" "web_server_ec2_2a" {
  ami               = data.aws_ami.ubuntu.id
  instance_type     = "t2.micro"
  availability_zone = "us-east-2a"
  key_name          = "ssh_OH"
  user_data         = filebase64("${path.module}/user_data/server_setup.sh")
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.ni_server_2a.id
  }
  tags = {
    Name = "web_server_ec2-2a"
  }
}

resource "aws_instance" "web_server_ec2_2b" {
  ami               = data.aws_ami.ubuntu.id
  instance_type     = "t2.micro"
  availability_zone = "us-east-2b"
  key_name          = "ssh_OH"
  user_data         = filebase64("server_setup.sh")

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.ni_server_2b.id
  }

  tags = {
    Name = "web_server_ec2-2b"
  }
}
